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
		const desktop = Quickshell.env("XDG_CURRENT_DESKTOP")
		if (desktop === "niri") {
			return SessionDesktop.niri
		} else if (desktop === "sway") {
			return SessionDesktop.sway
		} else if (desktop === "hyprland") {
			console.error("Running in a Hyprland session, which is not supported due to security reasons!")
			return SessionDesktop.hyprland
		}
		console.error("The current desktop is not supported or could not be detected correctly. Things may be broken!")
		return SessionDesktop.unknown
	}
	readonly property string sessionDesktopStr: SessionDesktop.toString(sessionDesktop)

	function dummyInit() {
	} // Needs to be called to bring the service to scope
	function poweroff() {
		Quickshell.execDetached(["systemctl", "poweroff"])
	}
	function reboot() {
		Quickshell.execDetached(["systemctl", "reboot"])
	}
	function suspend() {
		Quickshell.execDetached(["systemctl", "suspend"])
	}
	function logout() {
		Quickshell.execDetached(["niri", "msg", "action", "quit", "-s"])
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
