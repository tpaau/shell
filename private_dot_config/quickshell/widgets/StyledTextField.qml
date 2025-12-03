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
	selectionColor: Theme.palette.text
	selectedTextColor: Theme.palette.textSelected

	background: Rectangle {
		id: bgRect
		anchors.fill: parent
		color: Theme.palette.surfaceBright
		radius: Math.min(width, height) / 2
	}
}
