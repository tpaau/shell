import QtQuick
import QtQuick.Layouts
import qs.components.quickSettings
import qs.widgets
import qs.config

QSButton {
	id: root

	enabled: true
	property bool toggled: true

	property alias icon: styledIcon.text
	property alias primaryText: textPrimary.text
	property alias secondaryText: textSecondary.text
	property alias innerToggle: innerToggle

	disabledColor: Theme.palette.buttonDarkDisabled
	regularColor: Theme.palette.buttonDarkRegular
	hoveredColor: Theme.palette.buttonDarkHovered
	pressedColor: Theme.palette.buttonDarkPressed

	function determineColor(): color {
		if (root.changeColors) {
			if (containsPress) {
				return root.pressedColor
			}
			else if (containsMouse && !innerToggle.containsMouse) {
				return root.hoveredColor
			}
			return root.regularColor
		}
		return null
	}

	readonly property color contentColor: {
		if (enabled) {
			return Theme.palette.text
		}
		return Theme.palette.textDim
	}

	StyledButton {
		id: innerToggle

		Layout.fillHeight: true
		implicitWidth: height

		disabledColor: Theme.palette.buttonDarkDisabled
		regularColor: toggled ? Theme.palette.buttonBrightRegular
			: Theme.palette.surface
		hoveredColor: toggled ? Theme.palette.buttonBrightHovered
			: Theme.palette.buttonDarkHovered
		pressedColor: toggled ? Theme.palette.buttonBrightPressed
			: Theme.palette.buttonDarkPressed

		readonly property color contentColor: {
			if (enabled) {
				if (toggled) {
					return Theme.palette.textInverted
				}
				return Theme.palette.text
			}
			return Theme.palette.textDim
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

	StyledIcon {
		color: root.contentColor
		font.pixelSize: Config.icons.size.smaller
		text: ""
	}
}
