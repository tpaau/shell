pragma Singleton

import Quickshell
import Quickshell.Io
import qs.utils

// Session data and management service
Singleton {
	id: root

	enum SessionDesktop {
		Niri,
		Sway,
		Hyprland,
		Unknown
	}

	// I used readonly aliases here so the values can't be overwritten by objects outside
	// of the service
	readonly property alias username: usernameProc.value
	readonly property int sessionDesktop: {
		const desktop = Quickshell.env("XDG_CURRENT_DESKTOP")
		if (desktop === "niri") {
			return SessionDesktop.Niri
		} else if (desktop === "sway") {
			return SessionDesktop.Sway
		} else if (desktop === "hyprland") {
			console.error("Running in a Hyprland session, which is not supported due to security reasons!")
			return SessionDesktop.Hyprland
		}
		console.error("The current desktop is not supported or could not be detected correctly. Things may be broken!")
		return SessionDesktop.Unknown
	}

	function dummyInit() {} // Needs to be called to bring the service to scope
	function poweroff(delay = 0.0) {
		Quickshell.execDetached(["systemctl", "poweroff"])
	}
	function reboot(delay = 0.0) {
		Quickshell.execDetached(["systemctl", "reboot"])
	}
	function suspend(delay = 0.0) {
		Quickshell.execDetached(["systemctl", "suspend"])
	}
	function logout(delay = 0.0) {
		if (sessionDesktop === SessionDesktop.niri) {
			Quickshell.execDetached(["niri", "msg", "action", "quit", "-s"])
		} else if (sessionDesktop === SessionDesktop.sway) {
			console.warn("Logout on Sway not yet supported!")
		} else {
			console.warn("Logout on this session is not supported!")
		}
	}
	function lock() {
		Quickshell.execDetached([Paths.scriptsDir + "/lock-screen.sh"])
	}

	Process {
		id: usernameProc
		running: true
		command: ["whoami"]
		property string value: ""
		stdout: StdioCollector {
			onStreamFinished: usernameProc.value = text.trim()
		}
	}
}
