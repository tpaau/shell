import QtQuick
import qs.widgets
import qs.services.config
import qs.services.config.theme

Rectangle {
	id: root

	property bool enabled: true
	property int theme: TextButton.Theme.Primary
	property M3AnimData animData: Anims.current.effects.fast
	property color contentColor: switch (theme) {
		case TextButton.Theme.Primary:
			return Theme.palette.on_primary
		case TextButton.Theme.Secondary:
			return Theme.palette.on_secondary
		case TextButton.Theme.Tertiary:
			return Theme.palette.on_tertiary
		default:
			return Theme.palette.on_surface
	}

	readonly property bool hovered: layer.containsMouse
	readonly property bool pressed: layer.containsPress

	signal clicked()
	signal pressAndHold()

	enum Theme {
		Surface,
		OnSurface,
		SurfaceContainer,
		OnSurfaceContainer,
		Text,
		Primary,
		Secondary,
		Tertiary
	}

	radius: Config.rounding.normal
	border {
		width: 1
		color: theme === TextButton.Theme.Text ? Theme.palette.on_surface : "transparent"
	}
	color: switch (theme) {
		case TextButton.Theme.Surface:
			return Theme.palette.surface
		case TextButton.Theme.OnSurface:
			return Theme.palette.surface_container_low
		case TextButton.Theme.SurfaceContainer:
			return Theme.palette.surface_container
		case TextButton.Theme.OnSurfaceContainer:
			return Theme.palette.surface_container_high
		case TextButton.Theme.Text:
			return "transparent"
		case TextButton.Theme.Primary:
			return Theme.palette.primary
		case TextButton.Theme.Secondary:
			return Theme.palette.secondary
		case TextButton.Theme.Tertiary:
			return Theme.palette.tertiary
		default:
			return "magenta"
	}

	Behavior on radius { M3NumberAnim { data: root.animData } }
	Behavior on topRightRadius { M3NumberAnim { data: root.animData } }
	Behavior on bottomRightRadius { M3NumberAnim { data: root.animData } }
	Behavior on bottomLeftRadius { M3NumberAnim { data: root.animData } }
	Behavior on topLeftRadius { M3NumberAnim { data: root.animData } }

	StateLayer {
		id: layer
		enabled: root.enabled
		color: root.contentColor
		onClicked: root.clicked()
		onPressAndHold: root.pressAndHold()
	}
}
