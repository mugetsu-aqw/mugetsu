Mugetsu - a faster Ruffle build for AdventureQuest Worlds
=======================================================

Newest version: https://github.com/mugetsu-aqw/mugetsu/releases/latest
(or double-click "Get the newest Mugetsu" in this folder)

What it is
----------
An UNOFFICIAL, modified build of Ruffle (the open-source Flash Player emulator, the same
player Artix's own Game Launcher uses). It plays AQW straight from Artix's servers
(game.aq.com) - no game files are included or changed.

The changes are all inside the player and make crowded rooms much smoother:
  - drawing work spread over all CPU cores; GPU effect layers sized to their content
  - avatar effects and glows drawn together on shared canvases instead of one by one
    (since 1.3: several times faster on laptops and built-in graphics)
  - much less work per frame in fights and when changing rooms
  - fixed memory leaks
  - smoother mouse handling and steadier frame pacing
  - fixes for crashes on AMD graphics and on graphics cards that run out of memory, and
    much less graphics memory used in heavy fights
It does not change gameplay, automate anything, or give any advantage.

Not affiliated with, endorsed by, or supported by Artix Entertainment or the Ruffle
project. Use at your own risk; check AQW's Terms of Service if you are unsure.

Requirements
------------
  - Windows 10 or 11, 64-bit
  - A graphics card with DirectX 12 or Vulkan support (NVIDIA GTX 600, AMD Radeon HD 7000,
    Intel 6th-gen Core or newer). Mugetsu uses DirectX 12: it is as fast as Vulkan or
    faster in the game and the graphics driver holds far less memory. Without DirectX 12,
    or if it does not start, Mugetsu uses Vulkan and tells you so.
    To choose yourself, right-click Mugetsu's title bar: Graphics: Automatic (recommended),
    Vulkan or DirectX 12. Mugetsu restarts with your choice and remembers it. Try the other
    one if the game window stays black or stutters.
  - Graphics memory (VRAM): 2 GB minimum with Quality set to LOW in AQW's options, 4 GB or
    more recommended. Crowded rooms use a lot of graphics memory, and Medium/High need much
    more of it: on a 2 GB card, High can run out in busy rooms (the screen may go black or
    stutter until you switch to Low or change rooms).
  - RAM: 8 GB minimum, 16 GB recommended. A crowded room needs about 1 to 1.3 GB (see the
    Memory limit in the right-click menu), plus what the graphics driver itself uses.
  - Any 64-bit processor.

How to use
----------
  1. Unzip the folder anywhere.
  2. Run Mugetsu.exe. The first time, Windows may show "Windows protected your PC"
     (SmartScreen) because the program isn't signed by a known publisher: click
     "More info", then "Run anyway".
  3. Log in as usual.
  Closing the game window closes everything.

  Settings: right-click anywhere on the game for Mugetsu's menu:
  Performance mode (fewer pixels: faster on weak graphics), Frame interpolation (smoother
  motion on strong PCs, off by default; with it on, also Frame pacing and an FPS limit),
  Memory limit, Free memory now, Show FPS and Update reminders. Point at a setting to see
  what it does. F11 (or Alt+Enter) switches full screen.

Safety and privacy
------------------
  - Nothing is installed and no admin rights are needed. Delete the folder to remove it.
  - Your login happens on AQW's own login screen, loaded from Artix's servers; Mugetsu
    never sees, stores or sends your password. It has no tracking or telemetry. Its only
    connections are to Artix's game servers; once on first start, to Cisco
    (ciscobinary.openh264.org) to download the free OpenH264 video decoder that Ruffle
    uses for in-game videos (checked against a fixed checksum before use); and once at
    startup, to GitHub to check whether there's a newer Mugetsu version (nothing about you
    is sent; it only shows a message, nothing is downloaded). To switch the check off, put
    an empty file named no-update-check next to Mugetsu.exe.
  - The log file contains no account details (no email, username or chat).
  - No Windows settings are changed. While it is open, Mugetsu runs at high priority and
    asks Windows not to slow it down for power saving.
  - Check your download against the SHA-256 checksum published with the release.

Low FPS on a laptop or older PC?
--------------------------------
  In AQW's Options, set Quality to LOW. Since 1.5.0, Medium and High cost much less than
  before on built-in graphics, but Low is still the fastest. AQW remembers the setting.
  When Mugetsu runs on built-in graphics with Quality on Medium or High and the game is
  clearly slow, it shows this tip once. It never changes the setting for you.

Contact
-------
  Questions, bug reports or feedback: Discord silver09415. When reporting a problem,
  include your log (see Notes below; it has no account details).

Notes
-----
  - Settings and logs: %LOCALAPPDATA%\ruffle (the log is overwritten each launch).

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
