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

	disabledColor: Theme.pallete.bg.c2
	regularColor: Theme.pallete.bg.c4
	hoveredColor: Theme.pallete.bg.c6
	pressedColor: Theme.pallete.bg.c8

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
			return Theme.pallete.fg.c4
		}
		return Theme.pallete.fg.c1
	}

	StyledButton {
		id: innerToggle

		Layout.fillHeight: true
		implicitWidth: height

		disabledColor: Theme.pallete.bg.c2
		regularColor: root.toggled ? Theme.pallete.fg.c4 : Theme.pallete.bg.c3
		hoveredColor: root.toggled ? Theme.pallete.fg.c6 : Theme.pallete.bg.c5
		pressedColor: root.toggled ? Theme.pallete.fg.c8 : Theme.pallete.bg.c7

		readonly property color contentColor: {
			if (enabled) {
				if (root.toggled) {
					return Theme.pallete.bg.c3
				}
				return Theme.pallete.fg.c4
			}
			return Theme.pallete.fg.c1
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
