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

## Table of contents
- [Screenshots](#screenshots)
- [Features](#features)
- [Dependencies](#dependencies)
- [Roadmap to alpha](#roadmap-to-alpha)
- [FAQ](#faq)
    - [Why isn't Hyprland supported?](#faq_why-not-hyprland)
    - [What window managers are supported?](#faq_supported_wms)
- [Credit](#credit)
    - [Other software](#credit_other-software)

<a name="screenshots"></a>
## Screenshots
That's what you're here for, right?


| Frieren | Rain Worl |
| - | - |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s1.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s2.jpg) |
| Application launcher | Lock screen |
| ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s3.jpg) | ![s1](https://github.com/tpaau/dots/blob/main/screenshots/s4.jpg) |


<a name="features"></a>
## Features
- [Material design](https://m3.material.io/)
- [Matugen](https://github.com/InioX/matugen) color generation
- Shell modules
    - Status bar
    - Notification service with cross-session persistence
    - Quick settings
    - Application launcher
    - Session lock with multiple authentication methods
    - Session management
- Support for the Niri compositor


<a name="dependencies"></a>
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
- UPower daemon
    - Power profiles daemon


<a name="roadmap-to-alpha"></a>
## Roadmap to alpha (subject to change)
- [ ] Add support for Sway/SwayFX
- [ ] Implement the settings app
- [ ] Implement the setup screen
- [ ] Add packages for Fedora and Arch
- [ ] Add a custom polkit agent
- [ ] Bluetooth and network settings
- [ ] Add dock

<a name="faq"></a>
## FAQ

<a name="faq_why-not-hyprland"></a>
### Why isn't Hyprland supported?
Hyprland has really bad [code quality](https://bugs.gentoo.org/930831),
[questionable security practices](https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/242),
and often crashes when ran under
[`hardened_malloc`](https://github.com/GrapheneOS/hardened_malloc).

<a name="faq_supported_wms"></a>
### What window managers are supported?
The only compositor currently supported is Niri, but Sway/SwayFX support will be added
in the future.


<a name="credit"></a>
## Credit
My dots would be worthless without the amazing software they are made for! Give
the devs of these projects a big thanks!
- [Quickshell](https://quickshell.org/)
- [Niri](https://github.com/YaLTeR/niri)
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch)


<a name="credit_other-software"></a>
### Other software
- [Depth Anything](https://github.com/LiheYoung/Depth-Anything) - Image depth generator
- [just](https://github.com/casey/just) - Just a command runner
