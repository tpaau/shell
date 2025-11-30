pragma Singleton

import Quickshell
import qs.utils

Singleton {
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
}
