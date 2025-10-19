pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	function poweroff() { poweroffProc.startDetached() }
	function reboot() { rebootProc.startDetached() }
	function suspend() { suspendProc.startDetached() }
	function logout() { logoutProc.startDetached() }
	function lock() { lockProc.startDetached() }
	function restartQs() {
		qsRefreshProc.startDetached()
	}

	Process {
		id: poweroffProc
		command: ["systemctl", "poweroff"]
	}
	Process {
		id: rebootProc
		command: ["systemctl", "reboot"]
	}
	Process {
		id: suspendProc
		command: ["systemctl", "suspend"]
	}
	Process {
		id: logoutProc
		command: ["niri", "msg", "action", "quit", "-s"]
	}
	Process {
		id: lockProc
		command: ["sh", "-c", "~/.local/bin/lock-screen.sh"]
	}
	Process {
		id: qsRefreshProc
		command: ["sh", "-c", "pkill qs && qs"]
	}
}
