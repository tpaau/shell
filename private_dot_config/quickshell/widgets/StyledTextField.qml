import QtQuick
import QtQuick.Controls
import qs.config

TextField {
	id: control

	property alias bgRect: bgRect

	color: Theme.palette.text
	placeholderTextColor: Theme.palette.textDim
	padding: Config.spacing.large
	font.pixelSize: Config.font.size.large

	background: Rectangle {
		id: bgRect
		implicitWidth: control.width
		implicitHeight: control.height
		color: Theme.palette.surfaceBright
		radius: Math.min(width, height) / 2
	}
}
