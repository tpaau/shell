import QtQuick
import qs.widgets
import qs.theme
import qs.config

MouseArea {
	id: root

	property bool checked: false
	property bool interactive: true
	property real disabledOpacity: 0.6
	property bool pressed: false

	implicitWidth: 40
	implicitHeight: 40
	onClicked: checked = !checked

	Rectangle {
		anchors.fill: parent
		radius: root.width
		opacity: root.containsPress || root.pressed ? 1.0 : 0.0
		color: Qt.alpha(Theme.palette.primary, 0.1)

		Behavior on opacity { M3NumberAnim { data: Anims.current.effects.fast } }
	}

	Rectangle {
		anchors.centerIn: parent
		implicitWidth: 18
		implicitHeight: 18
		color: root.checked ? Theme.palette.primary : "transparent"
		radius: 2
		opacity: root.enabled ? 1.0 : root.disabledOpacity
		border {
			width: root.checked ? 0 : 2
			color: Theme.palette.outline
		}

		StyledIcon {
			anchors.centerIn: parent
			visible: root.checked
			font.pixelSize: 18
			color: Theme.palette.surface
			text: "check"
		}
	}
}
