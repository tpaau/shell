<h1 align="center">
dots
</h1>

<div align="center">

![](https://img.shields.io/github/last-commit/tpaau/dots?&style=for-the-badge&color=FFFFFF&logo=git&logoColor=C9C9C9&labelColor=252525)
![](https://img.shields.io/github/repo-size/tpaau/dots?&style=for-the-badge&color=FFFFFF&logo=git&logoColor=C9C9C9&labelColor=252525)

</div>

My custom desktop shell made with Quickshell for Niri.

> [!WARNING]
> This project is early development, and I do not provide an installation
> method yet.
>
> If you want to get updates on the state of the project, and to let
> me know that you *do* want to see this shell released, consider
> starring this repo!

## Screenshots
That's what you're here for, right?

| Neovim | Notification daemon |
| - | - |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s1.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s2.jpg) |
| Quick settings | Session management |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s3.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s4.jpg) |

## Dependencies
- Niri
- Quickshell
- Material symbols
- swayidle
- landrun (optional, but strongly recommended)
- swaylock (optional, but strongly recommended)
- systemd
<!-- - wl-clipboard -->
<!-- - python -->
<!-- 	- psutil -->
- fastfetch (optional)
- Noto fonts (optional, you can use any font you like)

## Why isn't Hyprland supported?
Hyprland has really bad [code quality](https://bugs.gentoo.org/930831), has
[questionable security practices](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/242#issuecomment-2244595525),
and often crashes when ran under
[`hardened_malloc`](https://github.com/GrapheneOS/hardened_malloc).

The only compositor currently supported is Niri, but Sway/SwayFX support may be added
in the future.


## Credit
My dots would be worthless without the amazing software they are made for! Give
the devs of these projects a big thanks!
- [Quickshell](https://quickshell.org/)
- [Niri](https://github.com/YaLTeR/niri)
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch)

### Other software
- [Depth Anything](https://github.com/LiheYoung/Depth-Anything) - image depth generator
- [chezmoi](https://www.chezmoi.io/) - dotfile manager
