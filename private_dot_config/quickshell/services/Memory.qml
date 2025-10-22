pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property int usage

	Process {
		id: memProc
		command: [Quickshell.shellDir + "/scripts/mem-usage.py"]
		running: true

		stdout: SplitParser {
			onRead: function(data) {
				root.usage = data
			}
		}
	}
}
