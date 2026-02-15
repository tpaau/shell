pragma Singleton

import Quickshell
import Quickshell.Io
import qs.services

Singleton {
	id: root

	readonly property int mode: Cache.caffeine.mode
	function setMode(mode: int): int {
		switch (mode) {
			case Caffeine.Mode.PreventSleep:
				Cache.caffeine.mode = mode
			case Caffeine.Mode.PreventIdle:
				Cache.caffeine.mode = mode
			default:
				return 1
		}
		return 0
	}

	readonly property bool running: Cache.caffeine.running
	function setRunning(running: bool) {
		Cache.caffeine.running = running
	}

	enum Mode {
		PreventSleep,
		PreventIdle
	}

	Process {
		id: preventSleepProc
		running: root.running && root.mode === Caffeine.Mode.PreventSleep
		command: ["systemd-inhibit", "--what=sleep", "--who=tpaau/shell", "--why=Caffeine process prevents the system from sleeping", "sleep", "2147483647"]
	}

	Process {
		id: preventIdleProc
		running: root.running && root.mode === Caffeine.Mode.PreventIdle
		command: ["systemd-inhibit", "--what=idle", "--who=tpaau/shell", "--why=Caffeine process prevents the system from idling", "sleep", "2147483647"]
	}
}
