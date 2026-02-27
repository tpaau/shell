import QtQuick
import QtQuick.Layouts
import qs.modules.quickSettings
import qs.widgets
import qs.services.config

QSButton {
	id: root

	enabled: true
	property bool toggled: true

	property alias icon: styledIcon.text
	property alias primaryText: textPrimary.text
	property alias secondaryText: textSecondary.text
	property alias innerToggle: innerToggle

	theme: StyledButton.Theme.OnSurfaceContainer

	function determineColor(): color {
		if (containsPress) {
			return root.pressedColor
		} else if (containsMouse && !innerToggle.containsMouse) {
			return root.hoveredColor
		}
		return root.regularColor
	}

	readonly property color contentColor: {
		if (enabled) {
			return Theme.palette.on_surface
		}
		return Qt.alpha(Theme.palette.on_surface, 0.7)
	}

	StyledButton {
		id: innerToggle

		Layout.fillHeight: true
		implicitWidth: height
		radius: root.radius - root.spacing

		theme: toggled ? StyledButton.Theme.Primary : StyledButton.Theme.OnSurfaceContainer

		readonly property color contentColor: {
			if (enabled) {
				if (toggled) {
					return Theme.palette.surface
				}
				return Theme.palette.on_surface
			}
			return Qt.alpha(Theme.palette.on_surface, 0.7)
		}

		StyledIcon {
			id: styledIcon
			anchors.centerIn: parent
			color: innerToggle.contentColor
			text: ""
		}
	}

	ColumnLayout {
		spacing: 0

		StyledText {
			id: textPrimary
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			font.pixelSize: Config.font.size.small
			color: root.contentColor
			text: "Primary text"
		}

		StyledText {
			id: textSecondary
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			visible: text && text != ""
			font.pixelSize: Config.font.size.smaller
			color: root.contentColor
			text: "Secondary text"
		}
	}
}
