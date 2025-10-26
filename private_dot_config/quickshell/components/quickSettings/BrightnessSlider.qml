import QtQuick
import QtQuick.Controls
import Quickshell.Io
import qs.widgets
import qs.config
import qs.utils

LargeStyledSlider {
	id: root
	implicitHeight: 40

	snapMode: Slider.SnapAlways
	stepSize: 0.05

	StyledIcon {
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			leftMargin: root.height / 4
		}
		text: {
			let brightness = root.value
			// Icons.pickIcon(brightness, ["", "", "", "", "", "", ""])
			Icons.pickIcon(brightness, ["", "", ""])
		}
		color: Theme.pallete.bg.c1
	}

	property bool ready: false
	onValueChanged: {
		if (ready) {
			setBrightnessProc.running = true
		}
		else {
			ready = true
		}
	}

	Process {
		id: setBrightnessProc
		command: ["brightnessctl", "s",
			Math.max(1, Math.round(root.value * 100)) + "%"]
	}

	Process {
		id: backglightProc
		running: true

		command: ["brightnessctl", "-P", "g"]

		stdout: StdioCollector {
			onStreamFinished: {
				let value = parseInt(text.trim()) / 100
				if (value <= 0.01) {
					root.value = 0
				}
				else {
					root.value = value
				}
			}
		}
	}
}
