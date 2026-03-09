pragma Singleton

import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Io
import qs.utils
import qs.services.notifications

// Session data and management service
Singleton {
	id: root

	// I used readonly aliases here so the values can't be overwritten by objects outside
	// of the service
	readonly property alias username: usernameProc.value
	readonly property int sessionDesktop: {
		const desktop = Quickshell.env("XDG_CURRENT_DESKTOP").toLowerCase()
		if (desktop === "niri") {
			console.log("Running in a Niri session.")
			return SessionDesktop.Type.Niri
		} else if (desktop === "sway") {
			const msg = "Running in a Sway session, which is not currently supported."
			console.warn(msg)
			Notifications.sendNotif(
				"Session not supported",
				msg,
				"Session",
				NotificationUrgency.Critical,
				[
					"Learn more",
					"https://github.com/tpaau/dots?tab=readme-ov-file#faq_supported_wms"
				]
			)
			return SessionDesktop.Type.Sway
		} else if (desktop === "hyprland") {
			const msg = "Running in a Hyprland session, which is not supported for to security reasons."
			console.error(msg)
			Notifications.sendNotif(
				"Session not supported",
				msg,
				"Session",
				NotificationUrgency.Critical,
				[
					"Why?",
					"xdg-open https://github.com/tpaau/dots?tab=readme-ov-file#faq_why-not-hyprland"
				]
			)
			return SessionDesktop.Type.Hyprland
		}
		const msg = "The current desktop is not supported or could not be detected correctly. Things may be broken!"
		Notifications.sendNotif(
			"Session not supported",
			msg,
			"Session",
			NotificationUrgency.Critical,
			[
				"Learn more",
				"xdg-open https://github.com/tpaau/dots?tab=readme-ov-file#faq_supported_wms"
			]
		)
		console.error(msg)
		return SessionDesktop.Type.Unknown
	}
	property string osName: "Unknown OS"

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
			console.warn("Logout in this session is not supported!")
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

    FileView {
        path: "/etc/os-release"
        onLoaded: {
            const lines = text().split("\n");
            let nameLine = lines.find(l => l.startsWith("PRETTY_NAME="));
            if (!nameLine)
                nameLine = lines.find(l => l.startsWith("NAME="));
            root.osName = nameLine.split("=")[1].replace(/"/g, "");
        }
    }
}
