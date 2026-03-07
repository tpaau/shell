pragma Singleton

import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	function set(value: int) {
		brightness = Utils.clamp(value, 0, 100)
		setBrightnessProc.running = true
	}

	function fetch() {
		getBrightnessProc.running = true
	}

	property int brightness

	Process {
		id: setBrightnessProc
		command: ["brightnessctl", "s",
			Math.max(1, Math.round(root.brightness)) + "%"]
	}

	Process {
		id: getBrightnessProc

		running: true
		command: ["brightnessctl", "-P", "g"]

		stdout: StdioCollector {
			onStreamFinished: {
				root.brightness = Utils.clamp(parseInt(text.trim()), 0, 100)
			}
		}
	}
}
