pragma Singleton

import Quickshell

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
		Quickshell.execDetached(["sh", "-c", "~/.local/bin/lock-screen.sh"])
	}
	function restartQs() {
		Quickshell.execDetached(["sh", "-c", "pkill qs && (qs &) && sleep 2 && notify-send \"Shell restarted\" \"Shell reloaded. I hope that fixed your, issue whatever it was! :)\" -a shell"])
	}
}
