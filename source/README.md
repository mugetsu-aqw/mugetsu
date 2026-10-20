# Mugetsu source

Mugetsu is [Ruffle](https://github.com/ruffle-rs/ruffle) (the open-source Flash Player emulator)
with changes for AdventureQuest Worlds. This folder holds those changes as patches on top of
Ruffle, plus the scripts that build `Mugetsu.exe` (Windows), `Mugetsu` (Linux) and `Mugetsu.app` from them.

Every release is built from this folder by GitHub Actions (`.github/workflows/build.yml`); each
run's page shows the build log and the SHA-256 of the files it made, which match the files on
the release page.

## What's here

| File | What it is |
|---|---|
| `RUFFLE_COMMIT` | The Ruffle commit Mugetsu is based on (nightly of 2026-10-02) |
| `RUST_VERSION` | The Rust version releases are built with |
| `patches/ruffle.patch` | All of Mugetsu's changes to Ruffle |
| `patches/wgpu-core.patch`, `wgpu-hal.patch`, `gc-arena.patch`, `lyon_path.patch`, `lyon_algorithms.patch` | Changes to five libraries Ruffle uses (wgpu-core 30.0.1, wgpu-hal 30.0.1, gc-arena 0.7.0, lyon_path 1.0.7, lyon_algorithms 1.0.5 from crates.io) |
| `pgo/aqw.profdata.zip` | The speed profile (PGO): counts of which code runs most while playing AQW, recorded with a measuring build. The compiler uses it to optimize for real play. It holds function names and counts only. |
| `build-window.ps1`, `build-linux.sh`, `build-macos.sh` | Download Ruffle at `RUFFLE_COMMIT` and the five libraries, apply the patches and build (Windows, Linux) |
| `release/`, `release-linux/`, `release-macos` | The other files in the Windows zip and the Linux archive (readme, license texts, notices) |
| `notes/` | Release notes, used for the draft release |

## Building it yourself (Windows)

You need [Rust](https://rustup.rs) (`rustup toolchain install 1.99.0`), Java 17 or newer (Ruffle
compiles its Flash classes with it) and git. Then, in this folder:

```
powershell -ExecutionPolicy Bypass -File build-window.ps1
```

The result is `build\out\Mugetsu.exe`. `-NoPgo` builds without the speed profile. A build takes
a while: Ruffle is a large program.

Your build won't be byte-for-byte identical to a release (file paths and the machine differ), but
it's made from the same code the same way.

## Building it yourself (Linux)

You need [Rust](https://rustup.rs) (`rustup toolchain install 1.99.0`), Java 17 or newer, git and
the development files of a few system libraries (on Debian or Ubuntu:
`sudo apt install build-essential pkg-config libasound2-dev libudev-dev libfontconfig-dev libfreetype6-dev libssl-dev`).
Then, in this folder:

```
./build-linux.sh
```

The result is `build/out/Mugetsu`. `--no-pgo` builds without the speed profile.

## Building it yourself (macOS)

You need macOS 11 or newer, [Rust](https://rustup.rs) (`rustup toolchain install 1.99.0`),
Java 17 or newer and git. Then, in this folder:

```
./build-macos.sh
```

The result is `build/out/Mugetsu.app` (and a release zip next to it). `--universal` builds one
app for Apple silicon and Intel; it needs both Rust targets (`rustup target add
aarch64-apple-darwin x86_64-apple-darwin`). The build uses no speed profile by default: the
one in `pgo/` was recorded on Windows. `--no-pgo` builds without the speed profile.

The macOS build uses Ruffle's macOS features (`fontconfig-dlopen`, so fontconfig is loaded
from the system at runtime and no Homebrew libraries are needed) and draws with Metal. The
app is ad-hoc signed, not notarized: macOS asks before the first start of an app downloaded
from the internet (right-click the app, then Open).

## What the changes do

Speed:
- Drawing work spread over all CPU cores; effect layers sized to their content and drawn
  together on shared canvases; glows and blurs drawn in batches; reused graphics memory.
- Shapes prepared on all cores, once, at the size they're drawn at (no stutter when entering a
  crowded room); mouse movement applied once per frame; steadier frame pacing and memory
  cleanup.
- Memory leaks fixed (weak-keyed `Dictionary`, unused game files freed), plus a faster memory
  allocator.
- DirectX 12: a faster command recorder and fixes, used by default on Intel and Qualcomm
  graphics.

Looking and working like Flash:
- 9-slice scaling (`scale9Grid`): stretched boxes keep their corners.
- Fonts: device-font substitutes with the right weight, embedded fonts looked up in Flash's
  order.
- Cutscenes stop at their Next buttons, chat scrolls and can be selected, newer Flash APIs are
  available to AQW, and more.

The app around it: AQW's address and settings built in, a settings menu on right-click
(graphics API choice in the title-bar menu too on Windows), crash and update messages, a
Quality tip for built-in graphics, and a performance log
(`%LOCALAPPDATA%\ruffle\log\ruffle.log`; on Linux `~/.cache/ruffle/log/ruffle.log`).

Comments in the code marked `AQW build:` explain each change.

## License

Mugetsu's changes are licensed under the GNU General Public License 3.0 (see `LICENSE` at the
top of this repository). Ruffle is dual-licensed MIT / Apache-2.0, wgpu-core, wgpu-hal,
lyon_path and lyon_algorithms are MIT / Apache-2.0 and gc-arena is MIT / CC0; their licenses
still apply to their code, and the release files include all license texts and notices.

Mugetsu isn't affiliated with or endorsed by Artix Entertainment or the Ruffle project.
