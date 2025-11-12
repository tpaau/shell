<h1 align="center">
dots
</h1>

<div align="center">

![](https://img.shields.io/github/last-commit/tpaau/dots?&style=for-the-badge&color=FFFFFF&logo=git&logoColor=C9C9C9&labelColor=252525)
![](https://img.shields.io/github/repo-size/tpaau/dots?&style=for-the-badge&color=FFFFFF&logo=git&logoColor=C9C9C9&labelColor=252525)

</div>

This is a repo where I dump most of my dotfiles, including my WM configuration,
desktop shell files, Neovim config, and `fastfetch` config. Feel free to use
this repo under the terms of the
[GPL license](https://github.com/tpaau/dots/blob/main/LICENSE)!

## Screenshots
That's what you're here for, right?

> [!WARNING]
> Those are outdated tho

| Fastfetch | Neovim |
| - | - |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s1.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s2.jpg) |
| Brightness OSD, Notification daemon | Quick settings |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s3.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s4.jpg) |

## Dependencies
- Niri
- Quickshell
- Material symbols
- swayidle
- swaylock (fallback in case the Quickshell lock fails for some reason)
- wl-clipboard
- rofi
- python
	- psutil
- fastfetch
- Noto fonts (optional, you can use any font you like)

## Shell performance
**Recommended hardware**
| | |
| - | - |
| CPU | Any "recent" quad-core processor |
| RAM | 4GB or more (recommended) |
| GPU | Any integrated graphics made in the last decade |
| Hard drive | Just please not an HDD |

**Resource usage on idle (default config, no wallpaper)**
| CPU | RAM |
| - | - |
| Almost none | ~180MB |


## Keybinds and IPC
All keybinds can be viewed by pressing `Mod`+`Shift`+`/`.

### Some quirks™
- Keyboard layout set to Polish 🇵🇱
- Caps Lock is mapped to Escape (Why would you use Caps Lock???)

You can view all the IPC commands by running `qs ipc show`:
```
target mediaControl
  function isAttached(): bool
  function togglePlaying(): int
  function play(): int
  function pause(): int
  function next(): string
  function previous(): int
  function getPlaybackState(): string
target appLauncher
  function toggleOpen(): int
  function close(): void
  function open(): int
target sessionManagement
  function open(): void
target sessionLock
  function lock(): int
```

Then run a command like so:
```
> qs ipc call sessionLock lock
0
```
The result of the call will be put to stdout.

## Installation
The project is far from being finished, and I do not provide an installation
method at this time. Consider starring this repository for updates.

## Why not Hyprland?
Hyprland often crashes when ran under [`hardened_malloc`](https://github.com/GrapheneOS/hardened_malloc),
has questionable security practices, and missing features.

## Credit
My dots would be worthless without the amazing software they are made for! Give
the devs of these projects a big thanks!
- [Quickshell](https://quickshell.org/)
- [Niri](https://github.com/YaLTeR/niri)
- [Neovim](https://neovim.io/)
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch)

Also give a big thanks to [twpayne](https://github.com/twpayne) for creating [chezmoi](https://www.chezmoi.io/), the tool that makes managing my dots a breeze!
