import QtQuick
import qs.services.config

MouseArea {
	id: root
	clip: true

	enum Theme {
		OnSurface,
		OnSurfaceContainer,
		Primary,
		Secondary,
		Tertiary
	}

	property alias rect: rect

	property real disabledOpacity: 0.7
	property int radius: Config.rounding.normal
	property int theme: StyledButton.Theme.OnSurfaceContainer
	property bool changeColors: true

	function blend(a: color, b: color): color {
		return Qt.rgba((a.r + b.r) / 2, (a.g + b.g) / 2, (a.b + b.b) / 2, 1)
	}

	property color regularColor: switch (theme) {
		case StyledButton.Theme.OnSurface:
			return Theme.palette.surface_container_low
		case StyledButton.Theme.OnSurfaceContainer:
			return Theme.palette.surface_container_high
		case StyledButton.Theme.Primary:
			return Theme.palette.primary_fixed_dim
		case StyledButton.Theme.Secondary:
			return Theme.palette.secondary_fixed_dim
		case StyledButton.Theme.Tertiary:
			return Theme.palette.tertiary_fixed_dim
		default:
			return "magenta"
	}
	property color hoveredColor: blend(regularColor, pressedColor)
	property color pressedColor: switch (theme) {
		case StyledButton.Theme.OnSurface:
			return Theme.palette.surface_container_high
		case StyledButton.Theme.OnSurfaceContainer:
			return Theme.palette.surface_bright
		case StyledButton.Theme.Primary:
			return Theme.palette.primary_fixed
		case StyledButton.Theme.Secondary:
			return Theme.palette.secondary_fixed
		case StyledButton.Theme.Tertiary:
			return Theme.palette.tertiary_fixed
		default:
			return "magenta"
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
		color: root.enabled ? root.determineColor() : Qt.alpha(root.regularColor, root.disabledOpacity)
		radius: root.radius

		Behavior on color {
			M3ColorAnim { data: Anims.current.effects.fast }
		}

		Behavior on radius {
			M3NumberAnim { data: Anims.current.effects.fast }
		}
	}
}
