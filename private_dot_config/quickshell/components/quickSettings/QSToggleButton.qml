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

	disabledColor: Theme.palette.buttonDarkDisabled
	regularColor: toggled ? Theme.palette.buttonBrightRegular : Theme.palette.buttonDarkRegular
	hoveredColor: toggled ? Theme.palette.buttonBrightHovered : Theme.palette.buttonDarkHovered
	pressedColor: toggled ? Theme.palette.buttonBrightPressed : Theme.palette.buttonDarkPressed

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
		font.pixelSize: Config.icons.size.large
		color: root.contentColor
		text: ""
	}
}
