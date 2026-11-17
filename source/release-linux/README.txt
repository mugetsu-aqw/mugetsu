Mugetsu - a faster Ruffle build for AdventureQuest Worlds (Linux)
=================================================================

Newest version: https://github.com/mugetsu-aqw/mugetsu/releases/latest

What it is
----------
An UNOFFICIAL, modified build of Ruffle (the open-source Flash Player emulator, the same
player Artix's own Game Launcher uses). It plays AQW straight from Artix's servers
(game.aq.com) - no game files are included or changed.

The changes are all inside the player and make crowded rooms much smoother:
  - drawing work spread over all CPU cores; GPU effect layers sized to their content
  - avatar effects and glows drawn together on shared canvases instead of one by one
  - much less work per frame in fights and when changing rooms
  - fixed memory leaks
  - smoother mouse handling and steadier frame pacing
It does not change gameplay, automate anything, or give any advantage.

Not affiliated with, endorsed by, or supported by Artix Entertainment or the Ruffle
project. Use at your own risk; check AQW's Terms of Service if you are unsure.

Requirements
------------
  - 64-bit Linux (x86-64) from about 2022 or newer: for example Ubuntu 22.04, Debian 12,
    Fedora 36, SteamOS 3, or newer. Wayland and X11 both work.
  - A graphics driver with Vulkan (Mesa for AMD and Intel, or NVIDIA's driver). Without
    Vulkan, Mugetsu uses OpenGL instead and tells you so (it works, but is slower).
    To choose yourself, right-click the game: Graphics: Auto (recommended), Vulkan or
    OpenGL. Mugetsu restarts with your choice and remembers it.
  - Graphics memory (VRAM): 2 GB minimum with Quality set to LOW in AQW's options, 4 GB or
    more recommended.
  - RAM: 8 GB minimum, 16 GB recommended.
  - Any 64-bit processor.
  - The usual desktop libraries (ALSA or PipeWire/PulseAudio sound, fontconfig, zlib,
    OpenSSL 3, libudev); desktop systems have them already.

How to use
----------
  1. Extract the archive anywhere (in a file manager, or: tar -xzf Mugetsu-*-linux.tar.gz).
  2. Run Mugetsu in the extracted folder (double-click it, or ./Mugetsu in a terminal).
  3. Log in as usual.
  Closing the game window closes everything.

  Settings: right-click anywhere on the game for Mugetsu's menu:
  Performance mode (fewer pixels: faster on weak graphics), Graphics, Frame interpolation
  (smoother motion on strong PCs, off by default; with it on, also Frame pacing and an FPS
  limit), Memory limit, Free memory now, Show FPS and Update reminders. Point at a setting
  to see what it does. F11 switches full screen.

Safety and privacy
------------------
  - Nothing is installed and no admin (root) rights are needed. Delete the folder to remove
    it.
  - Your login happens on AQW's own login screen, loaded from Artix's servers; Mugetsu
    never sees, stores or sends your password. It has no tracking or telemetry. Its only
    connections are to Artix's game servers; once on first start, to Cisco
    (ciscobinary.openh264.org) to download the free OpenH264 video decoder that Ruffle
    uses for in-game videos (checked against a fixed checksum before use); and once at
    startup, to GitHub to check whether there's a newer Mugetsu version (nothing about you
    is sent; it only shows a message, nothing is downloaded). To switch the check off, put
    an empty file named no-update-check next to Mugetsu.
  - The log file contains no account details (no email, username or chat).
  - No system settings are changed.
  - Check your download against the SHA-256 checksum published with the release
    (sha256sum Mugetsu-*-linux.tar.gz).

Low FPS on a laptop or older PC?
--------------------------------
  In AQW's Options, set Quality to LOW. AQW remembers the setting. Mugetsu never changes
  it for you.

Contact
-------
  Questions, bug reports or feedback: Discord silver09415. When reporting a problem,
  include your log (see Notes below; it has no account details).

Notes
-----
  - Settings: ~/.config/ruffle. Log: ~/.cache/ruffle/log (overwritten each launch).
  - ./Mugetsu --gui also shows Ruffle's menu bar, with a Mugetsu menu holding the same
    settings.

Licenses
--------
Mugetsu is a modified build of Ruffle (dual-licensed MIT / Apache-2.0) using modified
wgpu-core and wgpu-hal (MIT / Apache-2.0), gc-arena (MIT / CC0), and lyon_path and
lyon_algorithms (MIT / Apache-2.0). Mugetsu's own changes are licensed under the GNU
General Public License 3.0, and its source code is published at
https://github.com/mugetsu-aqw/mugetsu/tree/main/source (each release is built from it by
GitHub). The license texts are in the LICENSES folder, and the notices and license texts
of all other included libraries and fonts are in THIRD-PARTY-NOTICES.txt.
It also includes the unmodified Symphonia audio decoder (symphonia, symphonia-core,
symphonia-bundle-mp3, symphonia-codec-aac, symphonia-metadata 0.5.5) and option-ext 0.2.0,
licensed under the Mozilla Public License 2.0; their source code is available at
https://github.com/pdeljanov/Symphonia and https://github.com/soc/option-ext .

OpenH264 Video Codec provided by Cisco Systems, Inc. (downloaded by Ruffle on first start,
under Cisco's license: https://www.openh264.org/BINARY_LICENSE.txt).
