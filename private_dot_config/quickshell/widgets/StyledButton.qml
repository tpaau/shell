import QtQuick
import qs.services.config

MouseArea {
	id: root
	clip: true

	enum Theme {
		Regular,
		Dark,
		Surface,
		Bright
	}

	property alias rect: rect

	property bool changeColors: true
	property int radius: Config.rounding.normal
	property int theme: StyledButton.Theme.Regular

	property color disabledColor: {
		if (theme == StyledButton.Theme.Regular) {
			return Theme.palette.buttonDisabled
		} else if (theme == StyledButton.Theme.Dark) {
			return Theme.palette.buttonDarkDisabled
		} else if (theme === StyledButton.Theme.Surface) {
			return Theme.palette.buttonRegular
		} else if (theme === StyledButton.Theme.Bright) {
			return Theme.palette.accentDarker
		} else {
			return "magenta"
		}
	}
	property color regularColor: {
		if (theme == StyledButton.Theme.Regular) {
			return Theme.palette.buttonRegular
		} else if (theme == StyledButton.Theme.Dark) {
			return Theme.palette.buttonDarkRegular
		} else if (theme === StyledButton.Theme.Surface) {
			return Theme.palette.surface
		} else if (theme === StyledButton.Theme.Bright) {
			return Theme.palette.accent
		} else {
			return "magenta"
		}
	}
	property color hoveredColor: {
		if (theme == StyledButton.Theme.Regular) {
			return Theme.palette.buttonHovered
		} else if (theme == StyledButton.Theme.Dark) {
			return Theme.palette.buttonDarkHovered
		} else if (theme === StyledButton.Theme.Surface) {
			return Theme.palette.surfaceBright
		} else if (theme === StyledButton.Theme.Bright) {
			return Theme.palette.accentBright
		} else {
			return "magenta"
		}
	}
	property color pressedColor: {
		if (theme == StyledButton.Theme.Regular) {
			return Theme.palette.buttonPressed
		} else if (theme == StyledButton.Theme.Dark) {
			return Theme.palette.buttonDarkPressed
		} else if (theme === StyledButton.Theme.Surface) {
			return Theme.palette.buttonDisabled
		} else if (theme === StyledButton.Theme.Bright) {
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
			M3ColorAnim { data: Anims.current.effects.fast }
		}

		Behavior on radius {
			M3NumberAnim { data: Anims.current.effects.fast }
		}
	}
}
