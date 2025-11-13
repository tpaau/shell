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

> [!WARNING]
> This is not a dotfiles collection you would install on your machine. My
> current goal is to have a desktop shell that **works for me**.
> Unfortunately, that means I do not provide an installation method of the
> project at this time.
>
> This doesn't mean this project won't see a release. It's just not my current
> priority. If you want to get updates on the state of the project, and to let
> me know that you *do* want to see this dots collection released, consider
> starring this repo!

## Screenshots
That's what you're here for, right?

> [!NOTE]
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
