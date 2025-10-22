pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property string temp
	property real usage

	Process {
		id: cpuTempProc
		command: [Quickshell.shellDir + "/scripts/cpu-temp.py"]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.temp = data
			}
		}
	}

	Process {
		id: cpuPercentProc
		command: [Quickshell.shellDir + "/scripts/cpu-usage.py"]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.usage = data
			}
		}
	}
}
