<h1 align="center">
tpaau/shell
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


| Frieren | Rain Worl |
| - | - |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s1.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s2.jpg) |
| Application launcher | Lock screen |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s3.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s4.jpg) |


## Features
- [Material design](https://m3.material.io/)
- [Matugen](https://github.com/InioX/matugen) color generation
- Shell modules
    - Status bar
    - Quick settings
    - Application launcher
    - Session lock with multiple authentication methods
    - Session management
- Support for the Niri compositor


## Dependencies
- Niri
- Quickshell
- systemd
- Material symbols
- swayidle
- swaylock
- fastfetch (optional)
- Noto fonts (optional, you can use any font you like)
- [matugen](https://github.com/InioX/matugen)

## Roadmap to alpha (subject to change)
- [ ] Add support for Sway/SwayFX
- [ ] Implement the settings app
- [ ] Implement the setup screen
- [ ] Add installation scripts for Fedora, Fedora Silverblue, secureblue, and Arch
- [ ] Add a custom polkit agent
- [ ] Bluetooth settings


## Why isn't Hyprland supported?
Hyprland has really bad [code quality](https://bugs.gentoo.org/930831),
[questionable security practices](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/242),
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
