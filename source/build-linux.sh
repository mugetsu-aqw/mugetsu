#!/usr/bin/env bash
# Builds Mugetsu from Ruffle's source and the patches in this folder.
#
#   ./build-linux.sh                  (with the speed profile)
#   ./build-linux.sh --no-pgo         (without it)
#   ./build-linux.sh --prepare-only   (patched source only, no build)
#
# Needs: Rust (the version in RUST_VERSION), Java 17+ (Ruffle compiles its Flash classes
# with it) and git. The result is build/out/Mugetsu.
#
# Optional, for building without downloads: MUGETSU_RUFFLE_REMOTE (a local clone of Ruffle
# to fetch the commit from) and MUGETSU_CRATES_DIR (a folder with the unpacked crates, e.g.
# Cargo's registry/src/index.crates.io-*).
set -Eeuo pipefail

no_pgo=0
prepare_only=0

usage() {
    cat <<USAGE
Usage: $(basename "$0") [--no-pgo] [--prepare-only]

Build Mugetsu's Linux binary from the pinned Ruffle commit.
The resulting binary is: source/build/out/Mugetsu

Environment:
  MUGETSU_RUFFLE_REMOTE  Ruffle git remote or local clone
  MUGETSU_CRATES_DIR     directory containing wgpu-core-30.0.1,
                         wgpu-hal-30.0.1, gc-arena-0.7.0,
                         lyon_path-1.0.7 and lyon_algorithms-1.0.5
USAGE
}
while (($#)); do
    case "$1" in
        --no-pgo) no_pgo=1 ;;
        --prepare-only) prepare_only=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    esac
    shift
done

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
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

# 4. Build. x86-64-v3 (AVX2) like the released builds; paths in the program are shortened.
# When several prefixes match, the last one given wins: most specific last.
flags=("-Ctarget-cpu=x86-64-v3"
    "--remap-path-prefix=$HOME=home" "--remap-path-prefix=$ruffle=ruffle")
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
(cd "$ruffle" && run cargo build --locked --package ruffle_desktop --profile dist)

mkdir -p "$out"
cp -f "$CARGO_TARGET_DIR/dist/ruffle_desktop" "$out/Mugetsu"
chmod +x "$out/Mugetsu"
echo "Built $out/Mugetsu"
