import QtQuick
import qs.services.config
import qs.services.config.theme

// Overlay for various controls (eg. buttons)
MouseArea {
	id: root

	property bool hoverBackground: true // Whether to change the background color on hover
    property real radius: parent?.radius ?? 0
	property color color: Theme.palette.primary
	property M3AnimData animData: Anims.current.effects.fast
	readonly property alias rect: rect

	anchors.fill: parent
	pressAndHoldInterval: Config.input.mouse.pressAndHoldInterval
    hoverEnabled: true

	Rectangle {
		id: rect
		radius: root.radius
		anchors.fill: parent

		readonly property real alpha: {
			if (root.enabled) {
				if (root.pressed) {
					return 0.12
				} else if (root.hoverBackground && root.containsMouse) {
					return 0.08
				}
			}
			return 0
		}
		color: Qt.alpha(root.color, alpha)

		Behavior on color { M3ColorAnim { data: root.animData } }
	}
}
