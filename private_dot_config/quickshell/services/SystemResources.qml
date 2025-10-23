pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property QtObject cpu: QtObject {
		property int temp: 0
		property real usage: 0
	}

	property QtObject ram: QtObject {
		property int usage: 0
	}

	Process {
		command: [Quickshell.shellDir + "/scripts/resource-monitor.py"]
		running: true
		stdout: SplitParser {
			onRead: (data) => {
				const event = JSON.parse(data)

				if (event.CPU) {
					root.cpu.usage = event.CPU.usage
					root.cpu.temp = event.CPU.temp
				}
				else if (event.RAM) {
					root.ram.usage = event.RAM.usage
				}
			}
		}
	}
}
