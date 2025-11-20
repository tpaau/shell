import QtQuick
import qs.config

MouseArea {
	id: root
	clip: true

	property alias rect: rect

	property color disabledColor: Theme.palette.buttonDisabled
	property color regularColor: Theme.palette.buttonRegular
	property color hoveredColor: Theme.palette.buttonHovered
	property color pressedColor: Theme.palette.buttonPressed

	property int margin: Config.spacing.small
	property int marginHorizontal: 0
	property int marginVertical: 0

	property bool changeColors: true
	property int radius: Config.rounding.normal

	hoverEnabled: true
	function determineColor(): color {
		if (root.changeColors) {
			if (containsPress) {
				return root.pressedColor
			}
			else if (containsMouse) {
				return root.hoveredColor
			}
			return root.regularColor
		}
		return null
	}

	pressAndHoldInterval: Config.input.mouse.pressAndHoldInterval

	Rectangle {
		id: rect
		anchors.fill: parent
		color: root.enabled ? root.determineColor() : root.disabledColor
		radius: root.radius

		Behavior on color {
			ColorAnimation {
				duration: Config.animations.durations.shorter
				easing.type: Config.animations.easings.colorTransition
			}
		}

		Behavior on radius {
			NumberAnimation {
				duration: Config.animations.durations.shorter
				easing.type: Config.animations.easings.colorTransition
			}
		}
	}
}
