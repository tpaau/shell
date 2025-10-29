pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {

	property alias enabled: proc.running

	Process {
		id: proc
		running: false
		command: ["systemd-inhibit", "sleep", "2147483647"]
	}
}
