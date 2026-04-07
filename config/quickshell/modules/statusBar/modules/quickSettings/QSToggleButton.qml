import QtQuick
import qs.widgets
import qs.config

IconButton {
	id: root
	implicitWidth: (Config.quickSettings.buttonWidth - spacing) / 2
	implicitHeight: Config.quickSettings.buttonHeight
	radius: Math.min(width, height) / 3
	theme: toggled ? StyledButton.Theme.Primary : StyledButton.Theme.OnSurfaceContainer
	clip: true

	required property int spacing

	property bool toggled: true

	icon {
		font.pixelSize: Config.icons.size.large
		text: ""
	}
}
