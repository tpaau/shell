import QtQuick
import qs.config

MouseArea {
	id: root
	clip: true

	property alias rect: rect

	property bool changeColors: true
	property int radius: Config.rounding.normal
	property int theme: ButtonTheme.regular

	property color disabledColor: {
		if (theme == ButtonTheme.regular) {
			return Theme.palette.buttonDisabled
		} else if (theme == ButtonTheme.dark) {
			return Theme.palette.buttonDarkDisabled
		} else if (theme === ButtonTheme.surface) {
			return Theme.palette.buttonRegular
		} else if (theme === ButtonTheme.bright) {
			return Theme.palette.accentDarker
		} else {
			return "magenta"
		}
	}
	property color regularColor: {
		if (theme == ButtonTheme.regular) {
			return Theme.palette.buttonRegular
		} else if (theme == ButtonTheme.dark) {
			return Theme.palette.buttonDarkRegular
		} else if (theme === ButtonTheme.surface) {
			return Theme.palette.surface
		} else if (theme === ButtonTheme.bright) {
			return Theme.palette.accent
		} else {
			return "magenta"
		}
	}
	property color hoveredColor: {
		if (theme == ButtonTheme.regular) {
			return Theme.palette.buttonHovered
		} else if (theme == ButtonTheme.dark) {
			return Theme.palette.buttonDarkHovered
		} else if (theme === ButtonTheme.surface) {
			return Theme.palette.surfaceBright
		} else if (theme === ButtonTheme.bright) {
			return Theme.palette.accentBright
		} else {
			return "magenta"
		}
	}
	property color pressedColor: {
		if (theme == ButtonTheme.regular) {
			return Theme.palette.buttonPressed
		} else if (theme == ButtonTheme.dark) {
			return Theme.palette.buttonDarkPressed
		} else if (theme === ButtonTheme.surface) {
			return Theme.palette.buttonDisabled
		} else if (theme === ButtonTheme.bright) {
			return Theme.palette.accentBrighter
		} else {
			return "magenta"
		}
	}

	property int margin: Config.spacing.small
	property int marginHorizontal: 0
	property int marginVertical: 0

	hoverEnabled: true
	function determineColor(): color {
		if (root.changeColors) {
			if (containsPress) {
				return root.pressedColor
			} else if (containsMouse) {
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
			M3ColorAnim {
				data: Anims.current.effects.fast
			}
		}

		Behavior on radius {
			M3NumberAnim {
				data: Anims.current.effects.fast
			}
		}
	}
}
