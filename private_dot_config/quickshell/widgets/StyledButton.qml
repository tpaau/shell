import QtQuick
import qs.services.config

MouseArea {
	id: root
	clip: true

	enum Theme {
		OnSurfaceContainer,
		Primary,
		Secondary,
		Tertiary
	}

	property alias rect: rect

	property real disabledOpacity: 0.7
	property int radius: Config.rounding.normal
	property int theme: StyledButton.Theme.OnSurfaceContainer

	function blend(a: color, b: color): color {
		return Qt.rgba((a.r + b.r) / 2, (a.g + b.g) / 2, (a.b + b.b) / 2, 1)
	}

	property color regularColor: switch (theme) {
		case StyledButton.Theme.OnSurfaceContainer:
			return Theme.palette.surface_container_high
		case StyledButton.Theme.Primary:
			return Theme.palette.primary
		case StyledButton.Theme.Secondary:
			return Theme.palette.secondary
		case StyledButton.Theme.Tertiary:
			return Theme.palette.tertiary
		default:
			return "magenta"
	}
	property color hoveredColor: blend(regularColor, pressedColor)
	property color pressedColor: switch (theme) {
		case StyledButton.Theme.OnSurfaceContainer:
			return Theme.palette.surface_bright
		case StyledButton.Theme.Primary:
			return Theme.palette.on_primary_fixed_variant
		case StyledButton.Theme.Secondary:
			return Theme.palette.on_secondary_fixed_variant
		case StyledButton.Theme.Tertiary:
			return Theme.palette.on_tertiary_fixed_variant
		default:
			return "magenta"
	}

	property int margin: Config.spacing.small
	property int marginHorizontal: 0
	property int marginVertical: 0

	function determineColor(): color {
		if (containsPress) {
			return root.pressedColor
		} else if (containsMouse) {
			return root.hoveredColor
		}
		return root.regularColor
	}

	hoverEnabled: true
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
