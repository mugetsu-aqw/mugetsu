#!/usr/bin/env bash
# Builds Mugetsu for macOS from Ruffle's source and the patches in this folder.
#
#   ./build-macos.sh                  (with the speed profile)
#   ./build-macos.sh --universal      (Apple silicon and Intel in one app, with the speed profile)
#   ./build-macos.sh --no-pgo         (without it)
#   ./build-macos.sh --prepare-only   (patched source only, no build)
#
# Needs: macOS, Rust (the version in RUST_VERSION), Java 17+ (Ruffle compiles its Flash
# classes with it) and git. The result is build/out/Mugetsu.app.
#
# The build uses Ruffle's macOS feature set (fontconfig loaded at runtime), so no Homebrew
# libraries are needed. The app is ad-hoc signed: macOS still asks before the first start
# of a build made on another Mac (right-click the app, then Open).
#
# Optional, for building without downloads: MUGETSU_RUFFLE_REMOTE (a local clone of Ruffle
# to fetch the commit from) and MUGETSU_CRATES_DIR (a folder with the unpacked crates, e.g.
# Cargo's registry/src/index.crates.io-*).
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"

universal=0
prepare_only=0
no_pgo=0

usage() {
    cat <<USAGE
Usage: $(basename "$0") [--universal] [--no-pgo] [--prepare-only]

Build Mugetsu's macOS app from the pinned Ruffle commit.
The resulting app is: source/build/out/Mugetsu.app

Environment:
  MUGETSU_RUFFLE_REMOTE  Ruffle git remote or local clone
  MUGETSU_CRATES_DIR     directory containing wgpu-core-30.0.1,
                         wgpu-hal-30.0.1, gc-arena-0.7.0,
                         lyon_path-1.0.7 and lyon_algorithms-1.0.5
  MACOSX_DEPLOYMENT_TARGET
                         minimum macOS version (default: 11.0)
USAGE
}
while (($#)); do
    case "$1" in
        --universal) universal=1 ;;
        --prepare-only) prepare_only=1 ;;
        --no-pgo) no_pgo=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

work="$root/build"
ruffle="$work/ruffle"
out="$work/out"

run() { "$@"; }

commit="$(tr -d '[:space:]' < "$root/RUFFLE_COMMIT")"
remote="${MUGETSU_RUFFLE_REMOTE:-https://github.com/ruffle-rs/ruffle.git}"

# 1. Ruffle at the commit Mugetsu is based on (only that commit is downloaded).
rm -rf "$ruffle"
mkdir -p "$ruffle"
run git -C "$ruffle" init -q
run git -C "$ruffle" fetch -q --depth 1 "$remote" "$commit"
run git -C "$ruffle" -c advice.detachedHead=false checkout -q FETCH_HEAD

# 2. Mugetsu's changes to Ruffle.
run git -C "$ruffle" apply --whitespace=nowarn "$root/patches/ruffle.patch"

# 3. The five libraries Mugetsu changes, from crates.io, patched into ruffle/patches/.
crates=(
    "wgpu-core:30.0.1"
    "wgpu-hal:30.0.1"
    "gc-arena:0.7.0"
    "lyon_path:1.0.7"
    "lyon_algorithms:1.0.5"
)
mkdir -p "$ruffle/patches"
for crate in "${crates[@]}"; do
    name="${crate%%:*}"
    version="${crate##*:}"
    full="$name-$version"
    dest="$ruffle/patches/$name"
    rm -rf "$dest"
    if [[ -n "${MUGETSU_CRATES_DIR:-}" ]]; then
        cp -a "$MUGETSU_CRATES_DIR/$full" "$dest"
    else
        archive="$work/$full.crate"
        curl --fail --location --silent --show-error \
            "https://static.crates.io/crates/$name/$full.crate" -o "$archive"
        unpack="$work/crates"
        mkdir -p "$unpack"
        run tar -xzf "$archive" -C "$unpack"
        mv "$unpack/$full" "$dest"
    fi
    rm -f "$dest/.cargo_vcs_info.json"
    # From Ruffle's folder: inside a repository, git apply skips paths outside the current folder.
    run git -C "$ruffle" apply --whitespace=nowarn -p1 "--directory=patches/$name" \
        "$root/patches/$name.patch"
done

if ((prepare_only)); then
    echo "Patched source ready in $ruffle"
    exit 0
fi

if [[ "$(uname -s)" != Darwin ]]; then
    echo "build-macos.sh builds macOS apps and has to run on macOS." >&2
    exit 1
fi

# 4. Build. Ruffle's macOS features: fontconfig is loaded at runtime (no Homebrew needed)
# and JPEG XR is enabled like in Ruffle's releases.
case "$(uname -m)" in
    arm64) host_arch=arm64 ;;
    x86_64) host_arch=x86_64 ;;
    *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
if ((universal)); then
    targets=(aarch64-apple-darwin x86_64-apple-darwin)
    arch_name=universal
    if command -v rustup >/dev/null 2>&1; then
        for target in "${targets[@]}"; do
            if ! rustup target list --installed | grep -qx "$target"; then
                run rustup target add "$target"
            fi
        done
    fi
else
    targets=()
    arch_name="$host_arch"
fi

export MACOSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-11.0}"

# Paths in the program are shortened, like the Windows and Linux builds.
flags=("--remap-path-prefix=$ruffle=ruffle" "--remap-path-prefix=$HOME=home")
if [[ -n "${CARGO_HOME:-}" ]]; then
    flags+=("--remap-path-prefix=$CARGO_HOME=cargo")
fi
if [[ -n "${MUGETSU_RUSTFLAGS:-}" ]]; then
    flags=( ${MUGETSU_RUSTFLAGS} )
elif ((no_pgo == 0)); then
    # The speed profile (PGO), recorded while playing AQW.
    pgo="$work/pgo"
    rm -rf "$pgo"
    mkdir -p "$pgo"
    run unzip -q -o "$root/pgo/aqw.profdata.zip" -d "$pgo"
    flags+=("-Cprofile-use=$pgo/aqw.profdata")
fi
export RUSTFLAGS="${flags[*]}"
export CARGO_TARGET_DIR="$work/target"

features="software_video,external_video,lzma,jpegxr,fontconfig-dlopen"
build=(cargo build --locked --package ruffle_desktop --profile dist
    --no-default-features --features "$features")
if ((universal)); then
    for target in "${targets[@]}"; do
        (cd "$ruffle" && run "${build[@]}" --target "$target")
    done
    mkdir -p "$work/universal"
    binary="$work/universal/Mugetsu"
    run lipo -create -output "$binary" \
        "$CARGO_TARGET_DIR/aarch64-apple-darwin/dist/ruffle_desktop" \
        "$CARGO_TARGET_DIR/x86_64-apple-darwin/dist/ruffle_desktop"
else
    (cd "$ruffle" && run "${build[@]}")
    binary="$CARGO_TARGET_DIR/dist/ruffle_desktop"
fi

# 5. The app bundle: binary, icon and Info.plist.
version="$(sed -n 's/^pub const VERSION: &str = "\(.*\)";$/\1/p' \
    "$ruffle/desktop/src/mugetsu.rs" | head -n 1)"
if [[ -z "$version" ]]; then
    echo "Couldn't read Mugetsu's version from desktop/src/mugetsu.rs" >&2
    exit 1
fi

app="$out/Mugetsu.app"
rm -rf "$app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
cp -f "$binary" "$app/Contents/MacOS/Mugetsu"
chmod +x "$app/Contents/MacOS/Mugetsu"
cp -f "$root/release-macos/Mugetsu.icns" "$app/Contents/Resources/Mugetsu.icns"

cat > "$app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleDisplayName</key>
    <string>Mugetsu</string>
    <key>CFBundleExecutable</key>
    <string>Mugetsu</string>
    <key>CFBundleIconFile</key>
    <string>Mugetsu</string>
    <key>CFBundleIdentifier</key>
    <string>com.mugetsu.aqw</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Mugetsu</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$version</string>
    <key>CFBundleSupportedPlatforms</key>
    <array>
        <string>MacOSX</string>
    </array>
    <key>CFBundleVersion</key>
    <string>$version</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.games</string>
    <key>LSMinimumSystemVersion</key>
    <string>$MACOSX_DEPLOYMENT_TARGET</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Mugetsu, based on Ruffle (MIT / Apache-2.0); Mugetsu's changes are GPL-3.0.</string>
</dict>
</plist>
PLIST
plutil -lint "$app/Contents/Info.plist" >/dev/null

# Ad-hoc signature: enough for macOS to run the app; not a Developer ID (no notarization).
run codesign --force --sign - --timestamp=none "$app"

# 6. The release zip: the app plus the readme, notices and licenses.
package="$work/package"
rm -rf "$package"
mkdir -p "$package/LICENSES"
cp -R "$app" "$package/"
cp -f "$root/release-macos/README.txt" "$package/"
cp -f "$root/release/THIRD-PARTY-NOTICES.txt" "$package/"
cp -f "$root/release/LICENSES/"* "$package/LICENSES/"
cp -f "$root/../LICENSE" "$package/LICENSES/Mugetsu-LICENSE-GPL-3.0.txt"

zip="$out/Mugetsu-$version-macos-$arch_name.zip"
rm -f "$zip"
# --norsrc: no AppleDouble ("._") files for the Windows/Linux readers of the zip.
run ditto -c -k --norsrc "$package" "$zip"

echo "Built $app"
echo "Zip:   $zip"
echo "The app is ad-hoc signed, not notarized: if macOS blocks the first start, right-click"
echo "the app, choose Open, then Open again."
