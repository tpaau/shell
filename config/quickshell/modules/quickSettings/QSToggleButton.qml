import QtQuick
import qs.widgets
import qs.services.config

StyledButton {
	id: root
	implicitWidth: (Config.quickSettings.buttonWidth - spacing) / 2
	implicitHeight: Config.quickSettings.buttonHeight
	radius: Math.min(width, height) / 3
	theme: toggled ? StyledButton.Theme.Primary : StyledButton.Theme.OnSurfaceContainer
	clip: true

	required property int spacing

	property bool toggled: true
	property alias icon: styledIcon.text

	StyledIcon {
		id: styledIcon
		anchors.centerIn: parent
		font.pixelSize: Config.icons.size.large
		color: root.contentColor
		text: ""
	}
}
