pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {

	property alias enabled: proc.running

	Process {
		id: proc
		running: false
		command: ["systemd-inhibit", "--what=idle", "--what=sleep", "--who=tpaau/shell", "--why=Caffeine process prevents the system from idling", "sleep", "2147483647"]
	}
}
