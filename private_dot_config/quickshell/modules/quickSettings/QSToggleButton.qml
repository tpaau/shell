import QtQuick
import qs.widgets
import qs.services.config

StyledButton {
	id: root
	implicitWidth: (Config.quickSettings.buttonWidth - spacing) / 2
	implicitHeight: Config.quickSettings.buttonHeight
	radius: Math.min(width, height) / 3
	theme: toggled ? StyledButton.Theme.Primary : StyledButton.Theme.OnSurface
	clip: true

	required property int spacing

	property bool toggled: true
	property alias icon: styledIcon.text

	readonly property color contentColor: {
		if (enabled) {
			if (toggled) {
				return Theme.palette.surface
			}
			return Theme.palette.primary_fixed
		}
		return Theme.palette.primary_fixed_dim
	}

	StyledIcon {
		id: styledIcon
		anchors.centerIn: parent
		font.pixelSize: Config.icons.size.large
		color: root.contentColor
		text: ""
	}
}
