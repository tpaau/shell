import QtQuick
import qs.widgets
import qs.theme
import qs.config

Rectangle {
	id: root

	implicitWidth: 52
	implicitHeight: 32
	radius: height
	color: switched ? Theme.palette.primary : Theme.palette.outline_variant
	layer.enabled: true
	opacity: enabled ? 1.0 : 0.6
	border {
		width: switched ? 0 : 2
		color: Theme.palette.outline
	}

	readonly property M3AnimData spatial: Anims.current.spatial.fast
	readonly property M3AnimData effects: Anims.current.effects.fast

	property bool interactive: true
	property bool enabled: true
	property bool switched: false
	onSwitchedChanged: switchAnim.restart()

	MouseArea {
		id: area
		anchors.fill: parent
		enabled: root.enabled
		onClicked: if (root.interactive) root.switched = !root.switched
	}

	Rectangle {
		id: thumb
		anchors.verticalCenter: parent.verticalCenter
		color: root.switched ? Theme.palette.on_primary : Theme.palette.outline
		x: root.switched ?
			parent.width - width - (parent.height - height) / 2
			: (parent.height - height) / 2

		property real implicitSize: area.containsPress ? 28 : 24
		implicitWidth: implicitSize
		implicitHeight: implicitSize
		radius: Math.min(width, height) / 2

		Behavior on implicitSize { M3NumberAnim { data: root.effects } }
		Behavior on x {
			enabled: switchAnim.running || opacityRestoreAnim.running
			M3NumberAnim { data: root.spatial }
		}

		StyledIcon {
			id: icon
			anchors.centerIn: parent
			font.pixelSize: 18
			color: root.color
			text: ""
			Component.onCompleted: text = root.switched ? "check" : "close"

			M3NumberAnim {
				id: switchAnim
				target: icon
				property: "opacity"
				data: root.effects
				duration: root.spatial.duration / 2
				from: icon.opacity
				to: 0.0
				onStarted: opacityRestoreAnim.stop()
				onFinished: {
					icon.text = root.switched ? "check" : "close"
					opacityRestoreAnim.restart()
				}
			}
			M3NumberAnim {
				id: opacityRestoreAnim
				target: icon
				property: "opacity"
				data: root.effects
				duration: root.spatial.duration / 2
				from: icon.opacity
				to: 1.0
				onStarted: switchAnim.stop()
			}
		}
	}
}
