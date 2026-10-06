# Mugetsu

**A faster way to play AdventureQuest Worlds on Windows.**
Crowded rooms, big fights and room changes stay at a smooth, steady 24 FPS (AQW's maximum).

### [⬇ Download the latest version](https://github.com/mugetsu-aqw/mugetsu/releases/latest)

Unzip, run `Mugetsu.exe`, log in. Nothing to install.

---

## What it is

Mugetsu is an **unofficial, modified build of [Ruffle](https://ruffle.rs)**, the open-source Flash Player
emulator that Artix's own Game Launcher also uses. It plays AQW straight from Artix's servers; no game
files are included or changed.

All the changes are inside the player:

- drawing work spread over all CPU cores
- much less work per frame in fights and when changing rooms
- fixed memory leaks that made long sessions slower and slower
- smoother mouse handling and frame pacing
- fixes for crashes on AMD graphics and on graphics cards that run out of memory

It **does not** change gameplay, automate anything, or give any advantage. It just draws the same game faster.

## How much faster?

In crowded rooms like Yulgar, Mugetsu holds a steady **24 FPS** (AQW's maximum).
On the same PC, Flash drops to **7–10 FPS** and standard Ruffle to **8–16 FPS**: Mugetsu is
**up to 3× faster** than both.

## Requirements

- Windows 10 or 11, 64-bit
- A graphics card with **Vulkan** (NVIDIA GTX 600 / AMD Radeon HD 7000 / Intel 6th-gen Core or newer).
  Without Vulkan, Mugetsu falls back to DirectX 12 (slower) and tells you so.
- **Graphics memory:** 2 GB minimum (with AQW's Quality set to **Low**), 4 GB or more recommended
- **RAM:** 8 GB minimum, 16 GB recommended
- **CPU with AVX2:** Intel 4th-gen Core (2013) or newer, AMD Ryzen or newer

## How to use

1. Download the zip from **[Releases](https://github.com/mugetsu-aqw/mugetsu/releases/latest)** and unzip it anywhere.
2. Run `Mugetsu.exe`. The first time, Windows may say *"Windows protected your PC"* because the program
   isn't signed by a known publisher: click **More info → Run anyway**.
3. Log in as usual.

**Low FPS on a laptop or older PC?** In AQW's Options, set **Quality to Low**. Edge smoothing is by far the
most expensive part of drawing crowded rooms on weak graphics chips; on Low even very weak integrated
graphics held 24 FPS in a full Battleon in testing.

## Safety and privacy

- **Nothing is installed**, no admin rights needed. Delete the folder to remove it.
- **Your password never touches Mugetsu**: you log in on AQW's own login screen, loaded from Artix's servers.
- **No tracking, telemetry or update checks.** The only connections are to Artix's game servers and, once,
  to Cisco to download the free OpenH264 video decoder Ruffle uses for in-game videos.
- **The log file contains no account details** (no email, username or chat).
- **VirusTotal scan:** [0 detections](https://www.virustotal.com/gui/file/ae6994c7eca9d951f2a16d3e4f1b612fee2487fea51865a6eb267ba3e2c859d5) (version 1.0)
- **SHA-256** of each release zip is listed on its release page, so you can check your download.

## FAQ

**Is this a bot or a cheat?**
No. It doesn't automate anything, change any game files, or send anything the game doesn't send itself.
It's a faster version of the same player Artix's launcher uses.

**Is it allowed?**
Mugetsu isn't affiliated with or endorsed by Artix Entertainment or the Ruffle project. It only changes how
the unmodified game is drawn, but use it at your own risk and check AQW's Terms of Service if you're unsure.

**Why does Windows warn me the first time?**
Mugetsu isn't code-signed (that costs money and requires a public identity), so Windows SmartScreen
doesn't recognize the publisher. Check the VirusTotal scan and the SHA-256 above if you want to verify it.

**Where are the logs and settings?**
`%LOCALAPPDATA%\ruffle` (the log is replaced each time you start Mugetsu).

## Licenses

Mugetsu is a modified build of Ruffle (MIT / Apache-2.0) with modified wgpu-core, wgpu-hal (MIT / Apache-2.0)
and gc-arena (MIT / CC0). License texts for these and all other included libraries and fonts are in the
`LICENSES` folder and `THIRD-PARTY-NOTICES.txt` in the download. OpenH264 Video Codec provided by
Cisco Systems, Inc.
