# Mugetsu

**A faster way to play AdventureQuest Worlds on Windows, Linux and macOS.**
Crowded rooms, big fights and room changes stay at a smooth, steady frame rate.

### [⬇ Download the latest version](https://github.com/mugetsu-aqw/mugetsu/releases/latest)

Unzip, run `Mugetsu.exe`, log in. Nothing to install. (Linux: extract the `-linux` archive and run `Mugetsu`.
macOS: unzip the `-macos-universal` zip and open `Mugetsu.app`.)

## Contact

Questions, bug reports or feedback: Discord **silver09415**. For help with the Linux version: Discord
**jonasalv0** first, or **silver09415**. When reporting a problem, include your log (`%LOCALAPPDATA%\ruffle\log\ruffle.log` on Windows,
`~/.cache/ruffle/log` on Linux; it has no account details).

---

## What it is

Mugetsu is an **unofficial, modified build of [Ruffle](https://ruffle.rs)**, the open-source Flash Player
emulator that Artix's own Game Launcher also uses. It plays AQW straight from Artix's servers; no game
files are included or changed.

All the changes are inside the player:

- drawing work spread over all CPU cores
- avatar effects and glows drawn together on shared canvases instead of one by one (since 1.3:
  several times faster on laptops and built-in graphics)
- much less work per frame in fights and when changing rooms
- fixed memory leaks that made long sessions slower and slower
- smoother mouse handling and frame pacing
- fixes for crashes on AMD graphics and on graphics cards that run out of memory, and much less
  graphics memory used in heavy fights

It **does not** change gameplay, automate anything, or give any advantage. It just draws the same game faster.

## How much faster?

In crowded rooms like Yulgar, Mugetsu held a steady **24 FPS** in testing (at a 24 FPS game setting).
On the same PC, Flash drops to **7–10 FPS** and standard Ruffle to **8–16 FPS**: Mugetsu is
**up to 3× faster** than both.

On a laptop with Intel UHD 620 graphics (Quality Low), version 1.3 holds **30 FPS** in a crowded room
where version 1.2 managed about 20, and draws each frame about **3.5× faster**.

## Requirements

- Windows 10 or 11, 64-bit, or 64-bit Linux from about 2022 on (Ubuntu 22.04, Debian 12, Fedora 36,
  SteamOS 3 or newer; Linux uses Vulkan or OpenGL, details in the README inside the Linux download),
  or macOS 11 (Big Sur) or newer on Apple silicon or Intel (uses Metal; details in the README inside
  the macOS download)
- A graphics card with **DirectX 12** or **Vulkan** (NVIDIA GTX 600 / AMD Radeon HD 7000 / Intel 6th-gen Core or newer).
  Since 2.0.0 Mugetsu uses DirectX 12 on Windows: it is as fast as Vulkan or faster in the game and the graphics
  driver holds far less memory. Without DirectX 12, or if it does not start, Mugetsu uses Vulkan and tells you so.
  To choose yourself, **right-click Mugetsu's title bar** → Graphics: Automatic, Vulkan or DirectX 12
  (try the other one if the window stays black or stutters).
- **Graphics memory:** 2 GB minimum (with AQW's Quality set to **Low**), 4 GB or more recommended
- **RAM:** 8 GB minimum, 16 GB recommended. With 8 GB, try the **Memory limit** in the right-click menu (2 GB).
- **Any 64-bit processor** (since 2.0.0; older versions needed one with AVX2)

## How to use

1. Download the `-windows.zip` from **[Releases](https://github.com/mugetsu-aqw/mugetsu/releases/latest)** and unzip it anywhere.
2. Run `Mugetsu.exe`. The first time, Windows may say *"Windows protected your PC"* because the program
   isn't signed by a known publisher: click **More info → Run anyway**.
3. Log in as usual.

**macOS:** unzip the `-macos-universal.zip` and open `Mugetsu.app`. The first time, macOS blocks it
because it isn't notarized by Apple: open **System Settings → Privacy & Security**, click **Open Anyway**
next to the message about Mugetsu, then confirm. The README inside the download has the steps for older macOS.

**Settings:** right-click anywhere on the game for Mugetsu's menu: **Performance mode**,
**Frame interpolation** (smoother motion on strong PCs, off by default; with it on, also **Frame pacing** and an
**FPS limit**), **Memory limit**, **Free memory now**, **Show FPS** and **Update reminders**. Point at a setting to
see what it does. **F11** switches full screen.

**Low FPS on a laptop or older PC?** In AQW's Options, set **Quality to Low**. Since 1.5.0, Medium and High
cost much less than before on built-in graphics, but Low is still the fastest. If Mugetsu notices built-in
graphics running slowly on Medium or High, it shows this tip once; it never changes the setting for you.
Since 2.0.0 there is also **Performance mode** (right-click → Balanced or Fast): it draws the game with fewer
pixels and stretches the picture over the window, a little softer and faster.

## Safety and privacy

- **Nothing is installed**, no admin rights needed. Delete the folder to remove it.
- **Your password never touches Mugetsu**: you log in on AQW's own login screen, loaded from Artix's servers.
- **No tracking or telemetry.** The only connections are to Artix's game servers; once, to Cisco to
  download the free OpenH264 video decoder Ruffle uses for in-game videos; and once at startup, to
  GitHub to check whether there's a newer Mugetsu version (nothing about you is sent; it only shows a
  message, nothing is downloaded). To switch the check off, put an empty file named `no-update-check`
  next to `Mugetsu.exe`.
- **The log file contains no account details** (no email, username or chat).
- **Open source.** All of Mugetsu's code is public in the [`source`](source) folder (GPL-3.0), and from version
  1.3.1 on, every release is built from it by GitHub Actions: each build's page shows its log and the SHA-256 of
  the zip it made.
- **VirusTotal (version 1.7.0):** [zip 0/66](https://www.virustotal.com/gui/file/d73d448258e0033c105ff701c06f3ee2d283659b7f00f8d1235d1e1c575f1d60) · [Mugetsu.exe 0/71](https://www.virustotal.com/gui/file/b8cc3a99a843e6ffa39075420a51d8ccdf4eb0253702eed674dfadacca0836bc) · [Linux archive 0/62](https://www.virustotal.com/gui/file/e96ff97e0cced4481ce1140de0e8f9c1659b593153ee7e88c2d83fd1d5db4940) · [macOS zip 0/64](https://www.virustotal.com/gui/file/34a49ae71ac88da094dafb0657731afc85e5f9df9eb1ac54de19b27ee0af0c0c)
- **SHA-256** of each release file is listed on its release page, so you can check your download.

## FAQ

**Is this a bot or a cheat?**
No. It doesn't automate anything, change any game files, or send anything the game doesn't send itself.
It's a faster version of the same player Artix's launcher uses.

**Is it allowed?**
Mugetsu isn't affiliated with or endorsed by Artix Entertainment or the Ruffle project. It only changes how
the unmodified game is drawn, but use it at your own risk and check AQW's Terms of Service if you're unsure.

**Why does Windows warn me the first time?**
Mugetsu isn't code-signed (that costs money and requires a public identity), so Windows SmartScreen
doesn't recognize the publisher. Check the VirusTotal scan and the SHA-256 above if you want to verify it,
or read the source code it's built from.

**Where are the logs and settings?**
`%LOCALAPPDATA%\ruffle` (the log is replaced each time you start Mugetsu).

## Licenses

Mugetsu's own changes are licensed under the [GPL-3.0](LICENSE); the source is in the [`source`](source) folder.
Mugetsu is a modified build of Ruffle (MIT / Apache-2.0) with modified wgpu-core, wgpu-hal (MIT / Apache-2.0)
and gc-arena (MIT / CC0). License texts for these and all other included libraries and fonts are in the
`LICENSES` folder and `THIRD-PARTY-NOTICES.txt` in the download. OpenH264 Video Codec provided by
Cisco Systems, Inc.
