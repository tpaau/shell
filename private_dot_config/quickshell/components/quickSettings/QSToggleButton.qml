import QtQuick
import qs.widgets
import qs.config

StyledButton {
	id: root
	implicitWidth: (Config.quickSettings.buttonWidth - spacing) / 2
	implicitHeight: Config.quickSettings.buttonHeight
	radius: Math.min(width, height) / 3
	clip: true

	required property int spacing

	property bool toggled: true
	property alias icon: styledIcon.text

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
		anchors.centerIn: parent
		font.pixelSize: Config.icons.size.large
		color: root.contentColor
		text: ""
	}
}
