import QtQuick
import qs.utils
import qs.services.config
import qs.services.config.theme

MouseArea {
	id: root
	clip: true

	enum Theme {
		Surface,
		OnSurface,
		SurfaceContainer,
		OnSurfaceContainer,
		Primary,
		Secondary,
		Tertiary
	}

	property alias rect: rect

	property real disabledOpacity: 0.6
	property int radius: Config.rounding.normal
	property int theme: StyledButton.Theme.OnSurfaceContainer

	property color regularColor: switch (theme) {
		case StyledButton.Theme.Surface:
			return Theme.palette.surface
		case StyledButton.Theme.OnSurface:
			return Theme.palette.surface_container_low
		case StyledButton.Theme.SurfaceContainer:
			return Theme.palette.surface_container
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
	property color hoveredColor: Utils.blendColor(regularColor, pressedColor)
	property color pressedColor: switch (theme) {
		case StyledButton.Theme.Surface:
			return Theme.palette.surface_container
		case StyledButton.Theme.OnSurface:
			return Theme.palette.surface_container_high
		case StyledButton.Theme.SurfaceContainer:
			return Theme.palette.surface_container_highest
		case StyledButton.Theme.OnSurfaceContainer:
			return Theme.palette.surface_bright
		case StyledButton.Theme.Primary:
			return Utils.blendColor(regularColor, Theme.palette.on_primary_fixed_variant)
		case StyledButton.Theme.Secondary:
			return Utils.blendColor(regularColor, Theme.palette.on_secondary_fixed_variant)
		case StyledButton.Theme.Tertiary:
			return Utils.blendColor(regularColor, Theme.palette.on_tertiary_fixed_variant)
		default:
			return "magenta"
	}

	property int margin: Config.spacing.small
	property int marginHorizontal: 0
	property int marginVertical: 0

	function determineColor(): color {
		if (enabled) {
			if (containsPress) {
				return root.pressedColor
			} else if (containsMouse) {
				return root.hoveredColor
			}
			return root.regularColor
		}
		return Qt.alpha(regularColor, disabledOpacity)
	}

	hoverEnabled: true
	pressAndHoldInterval: Config.input.mouse.pressAndHoldInterval

	Rectangle {
		id: rect
		anchors.fill: parent
		color: root.determineColor()
		radius: root.radius

		Behavior on color {
			M3ColorAnim { data: Anims.current.effects.fast }
		}

		Behavior on radius {
			M3NumberAnim { data: Anims.current.effects.fast }
		}
	}
}
