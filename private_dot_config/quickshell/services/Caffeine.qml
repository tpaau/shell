pragma Singleton

import Quickshell
import Quickshell.Io
import qs.services.cache

Singleton {
	id: root

	readonly property string modeStr: running ? getModeName(mode) : "Off"
	readonly property int mode: Cache.caffeine.mode
	function setMode(mode: int): int {
		mode = mode
	}
	readonly property bool running: Cache.caffeine.running
	function setRunning(running: bool) {
		Cache.caffeine.running = running
	}

	function getModeName(mode: int): string {
		switch (mode) {
			case Caffeine.Mode.PreventSleep:
				return "Prevent sleep"
			case Caffeine.Mode.PreventIdle:
				return "Prevent idle"
			case Caffeine.Mode.PreventIdleAndSleep:
				return "Prevent idle and sleep"
			default:
				return "Unknown mode"
		}
	}

	enum Mode {
		PreventSleep,
		PreventIdle,
		PreventIdleAndSleep
	}

	Process {
		id: preventSleepProc
		running: root.running && (root.mode === Caffeine.Mode.PreventSleep || root.mode === Caffeine.Mode.PreventIdleAndSleep)
		command: ["systemd-inhibit", "--what=sleep", "--who=tpaau/shell", "--why=Caffeine process prevents the system from sleeping", "sleep", "2147483647"]
	}

	Process {
		id: preventIdleProc
		running: root.running && (root.mode === Caffeine.Mode.PreventIdle || root.mode === Caffeine.Mode.PreventIdleAndSleep)
		command: ["systemd-inhibit", "--what=idle", "--who=tpaau/shell", "--why=Caffeine process prevents the system from idling", "sleep", "2147483647"]
	}
}
