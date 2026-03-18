<h1 align="center">
tpaau/shell
</h1>

<div align="center">

![](https://img.shields.io/github/last-commit/tpaau/dots?&style=for-the-badge&color=FFFFFF&logo=git&logoColor=C9C9C9&labelColor=252525)
![](https://img.shields.io/github/repo-size/tpaau/dots?&style=for-the-badge&color=FFFFFF&logo=git&logoColor=C9C9C9&labelColor=252525)

My custom desktop shell made with Quickshell for Niri.

</div>

> [!WARNING]
> This project is early development, and I do not provide an installation
> method yet. You can still [try the shell](#try-it), though!
>
> If you want to get updates on the state of the project, and to let
> me know that you *do* want to see this shell released, consider
> starring this repo!

## Table of contents
- [Screenshots](#screenshots)
- [Features](#features)
- [Dependencies](#dependencies)
- [Try it](#try-it)
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
- swayidle (to be removed)
- swaylock (to be removed)
- [matugen](https://github.com/InioX/matugen)
- UPower daemon
    - Power profiles daemon


<a name="try-it"></a>
## Try it
While I do not provide an installation method just yet, you can still try the shell!

1. Clone the shell
```
git clone https://github.com/tpaau/shell
cd shell
```

2. Install [required dependencies](#dependencies)
- You will also need `cargo` and optionally [`just`](https://github.com/casey/just)
- `swaylock` is not a required dependency since you're just testing things out

3. Run the shell

> [!WARNING]
> The shell will mess with Niri config files in `~/.config/niri`.
>
> Please make sure to back them up.

Run `just run-dev`, or copy the list of commands from the `justfile` and run them
manually.

> [!NOTE]
> The shell will create its data, config, and cache directories:
> - `~/.local/share/tpaau-shell/`
> - `~/.config/tpaau-shell/`
> - `~/.cache/tpaau-shell/`
>
> You can easily remove them with `just rm-shell-dirs`.


<a name="roadmap-to-alpha"></a>
## Roadmap to alpha (subject to change)
- [ ] Add support for Sway/SwayFX
- [ ] Add the settings app
- [ ] Implement the setup screen
- [ ] Create packages for Fedora and Arch
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


<a name="credit_other-software"></a>
### Other software
- [Depth Anything](https://github.com/LiheYoung/Depth-Anything) - Image depth generator
- [just](https://github.com/casey/just) - Just a command runner
