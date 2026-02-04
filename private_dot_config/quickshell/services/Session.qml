pragma Singleton

import Quickshell
import Quickshell.Io
import qs.utils

// Session data and management service
Singleton {
	id: root

	// I used readonly aliases here so the values can't be overwritten by objects outside
	// of the service
	readonly property alias username: usernameProc.value
	readonly property int sessionDesktop: {
		const desktop = Quickshell.env("XDG_CURRENT_DESKTOP").toLowerCase()
		if (desktop === "niri") {
			return SessionDesktop.Type.Niri
		} else if (desktop === "sway") {
			return SessionDesktop.Type.Sway
		} else if (desktop === "hyprland") {
			console.error("Running in a Hyprland session, which is not supported due to security reasons!")
			return SessionDesktop.Type.Hyprland
		}
		console.error("The current desktop is not supported or could not be detected correctly. Things may be broken!")
		return SessionDesktop.Type.Unknown
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
		if (sessionDesktop === SessionDesktop.Type.Niri) {
			Quickshell.execDetached(["niri", "msg", "action", "quit", "-s"])
		} else if (sessionDesktop === SessionDesktop.Type.Sway) {
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
