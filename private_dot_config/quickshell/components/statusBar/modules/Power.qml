import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.utils
import qs.config

Rectangle {
	id: root

	implicitWidth: needsAttention ? layout.width + 20 : layout.width
	color: needsAttention ? Theme.pallete.fg.c8 : Theme.pallete.bg.c1
	radius: Math.min(width, height) / 2

	readonly property UPowerDevice device: UPower.displayDevice
	property bool needsAttention: switch(device.state) {
		case UPowerDeviceState.Discharging:
			return true
		case UPowerDeviceState.Charging:
			return true
		default:
			return false
	}

	Behavior on color {
		ColorTransition {
			id: anim
		}
	}

	Behavior on implicitWidth {
		NumberAnimation {
			duration: anim.duration
			easing.type: anim.easing.type
		}
	}

	RowLayout {
		id: layout
		anchors.centerIn: parent

		StyledIcon {
			id: icon
			color: root.needsAttention ? Theme.pallete.bg.c1 : Theme.pallete.fg.c8
			Layout.topMargin: 2
			text: {
				if (UPower.displayDevice.ready) {
						return Icons.pickIcon(UPower.displayDevice.percentage,
						["", "", "", "", "", "", "", ""])
				}
				else {
					return ""
				}
			}

			Behavior on color {
				ColorTransition {}
			}
		}

		StyledText {
			color: root.needsAttention ? Theme.pallete.bg.c1 : Theme.pallete.fg.c8
			text: root.device.ready ?
				Math.round(root.device.percentage * 100).toString() + "%"
				: "0%"
		}
	}
}
