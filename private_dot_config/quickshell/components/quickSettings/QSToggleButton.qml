import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

QSButton {
	id: root

	enabled: true
	property bool toggled: true

	property alias icon: styledIcon.text
	property alias primaryText: textPrimary.text
	property alias secondaryText: textSecondary.text

	disabledColor: Theme.pallete.bg.c2
	regularColor: toggled ? Theme.pallete.fg.c4 : Theme.pallete.bg.c4
	hoveredColor: toggled ? Theme.pallete.fg.c6 : Theme.pallete.bg.c5
	pressedColor: toggled ? Theme.pallete.fg.c8 : Theme.pallete.bg.c6

	readonly property color contentColor: {
		if (enabled) {
			if (toggled) {
				return Theme.pallete.bg.c3
			}
			return Theme.pallete.fg.c4
		}
		return Theme.pallete.fg.c1
	}

	StyledIcon {
		id: styledIcon
		color: root.contentColor
		text: ""
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
			visible: text && text != ""
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			font.pixelSize: Config.font.size.smaller
			color: root.contentColor
			text: "Secondary text"
		}
	}
}
