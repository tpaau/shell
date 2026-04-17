import QtQuick
import qs.widgets
import qs.theme
import qs.config

Rectangle {
	id: root

	property bool enabled: true
	// Whether to change the background color on hover
	property bool hoverBackground: true
	// Whether to render a ripple effect when pressed
	property bool rippleEnabled: Config.appearance.ripple.enabled
	// Opacity when the button is disabled
	property real dimmedOpacity: 0.7
	property int theme: StyledButton.Theme.Primary
	property M3AnimData animData: Anims.current.effects.fast
	property color contentColor: switch (theme) {
		case StyledButton.Primary:
			return Theme.palette.on_primary
		case StyledButton.PrimaryInactive:
			return Theme.palette.primary
		case StyledButton.Secondary:
			return Theme.palette.on_secondary
		case StyledButton.SecondaryInactive:
			return Theme.palette.secondary
		case StyledButton.Tertiary:
			return Theme.palette.on_tertiary
		case StyledButton.TertiaryInactive:
			return Theme.palette.tertiary
		default:
			return Theme.palette.on_surface
	}

	readonly property alias rect: rect
	readonly property alias hovered: overlay.containsMouse
	readonly property alias pressed: overlay.containsPress

	signal clicked()
	signal pressAndHold()

	enum Theme {
		Surface,
		OnSurface,
		SurfaceContainer,
		OnSurfaceContainer,
		Text,
		Primary,
		PrimaryInactive,
		Secondary,
		SecondaryInactive,
		Tertiary,
		TertiaryInactive
	}

	clip: true
	radius: Config.rounding.normal
	border {
		width: 1
		color: theme === StyledButton.Theme.Text ? Theme.palette.on_surface : "transparent"
	}
	color: switch (theme) {
		case StyledButton.Theme.Surface:
			return Theme.palette.surface
		case StyledButton.Theme.OnSurface:
			return Theme.palette.surface_container_low
		case StyledButton.Theme.SurfaceContainer:
			return Theme.palette.surface_container
		case StyledButton.Theme.OnSurfaceContainer:
			return Theme.palette.surface_container_high
		case StyledButton.Theme.Text:
			return "transparent"
		case StyledButton.Theme.Primary:
			return Theme.palette.primary
		case StyledButton.Theme.PrimaryInactive:
			return Theme.palette.primary_container
		case StyledButton.Theme.Secondary:
			return Theme.palette.secondary
		case StyledButton.Theme.SecondaryInactive:
			return Theme.palette.secondary_container
		case StyledButton.Theme.Tertiary:
			return Theme.palette.tertiary
		case StyledButton.Theme.TertiaryInactive:
			return Theme.palette.tertiary_container
		default:
			return "magenta"
	}
	opacity: enabled ? 1.0 : dimmedOpacity

	Behavior on color { M3ColorAnim { data: root.animData } }
	Behavior on radius { M3NumberAnim { data: root.animData } }
	Behavior on topRightRadius { M3NumberAnim { data: root.animData } }
	Behavior on bottomRightRadius { M3NumberAnim { data: root.animData } }
	Behavior on bottomLeftRadius { M3NumberAnim { data: root.animData } }
	Behavior on topLeftRadius { M3NumberAnim { data: root.animData } }

	MouseArea {
		id: overlay

		readonly property alias rect: rect

		anchors.fill: parent
		pressAndHoldInterval: Config.input.mouse.pressAndHoldInterval
		hoverEnabled: true
		enabled: root.enabled
		onPressed: mouse => {
			ripple.trigger(mouse.x, mouse.y)
		}
		onClicked: root.clicked()
		onPressAndHold: root.pressAndHold()

		Rectangle {
			id: rect
			radius: root.radius
			topRightRadius: root.topRightRadius
			bottomRightRadius: root.bottomRightRadius
			bottomLeftRadius: root.bottomLeftRadius
			topLeftRadius: root.topLeftRadius
			anchors.fill: parent

			readonly property real alpha: {
				if (overlay.enabled) {
					if (overlay.pressed) {
						return 0.1
					} else if (root.hoverBackground && overlay.containsMouse) {
						return 0.06
					}
				}
				return 0
			}
			color: Qt.alpha(root.contentColor, alpha)

			Behavior on color { M3ColorAnim { data: root.animData } }
		}

		Ripple {
			id: ripple
			color: root.contentColor
			radius: root.radius
			enabled: root.rippleEnabled
		}
	}
}
