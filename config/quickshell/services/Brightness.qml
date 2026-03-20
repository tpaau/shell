pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.widgets.toast
import qs.config
import qs.utils
import qs.services

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

	readonly property string icon: Icons.pickIcon(brightness / 100, ["", "", ""])

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

	Loader {
		active: Config.toast.brightness
		asynchronous: true

		sourceComponent: Item {
			Component {
				id: brightnessOsd
				ToastProgressIndicator {
					icon: root.icon
					progress: root.brightness / 100
					onProgressChanged: restartTimer()
				}
			}

			Connections {
				target: root

				function onBrightnessChanged() {
					Ipc.displayIndicatorToast(brightnessOsd)
				}
			}
		}
	}
}
