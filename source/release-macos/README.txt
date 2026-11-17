Mugetsu - a faster Ruffle build for AdventureQuest Worlds (macOS)
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
  - macOS 11 (Big Sur) or newer, Apple silicon or Intel
  - A Mac with Metal support (every Mac that runs macOS 11)
  - RAM: 8 GB minimum, 16 GB recommended. A crowded room needs about 1 to 1.3 GB (see the
    Memory limit in the right-click menu).
  - Graphics memory: on Apple silicon the graphics chip shares the Mac's memory. Crowded
    rooms use a lot of it, and AQW's Quality setting (Medium/High) uses much more: if
    rooms get slow, set Quality to Low in AQW's options.

How to use
----------
  1. Unzip the download.
  2. Open Mugetsu.app. The first time, macOS blocks it because Apple hasn't checked it (it's
     ad-hoc signed, not notarized): click Done, open System Settings > Privacy & Security,
     scroll down to the message about Mugetsu and click Open Anyway, then confirm. On
     macOS 14 or older, right-clicking (or Control-clicking) Mugetsu.app and choosing Open
     also works.
  3. Log in as usual.
  Closing the game window closes everything.

  Settings: right-click anywhere on the game for Mugetsu's menu:
  Performance mode (fewer pixels: faster on weak graphics), Frame interpolation (smoother
  motion on strong Macs, off by default; with it on, also Frame pacing and an FPS limit),
  Memory limit, Free memory now, Show FPS and Update reminders. Point at a setting to see
  what it does. F11 switches full screen.

  Mugetsu keeps its settings in ~/Library/Application Support/ruffle and its log in
  ~/Library/Caches/ruffle/log.

Command line
------------
Mugetsu.app/Contents/MacOS/Mugetsu takes Ruffle's usual options, e.g.

  Mugetsu.app/Contents/MacOS/Mugetsu --width 1280 --height 720
  Mugetsu.app/Contents/MacOS/Mugetsu some-movie.swf

Mugetsu always draws with Metal on macOS. Unlike the Windows build there is no graphics
choice in its menu.
