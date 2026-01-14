import QtQuick
import QtQuick.Controls
import qs.config

TextField {
	id: root

	property int radius: Config.rounding.normal
	property int borderWidth: Config.border.width
	property color bgColor: Theme.palette.background
	property color borderColor: Theme.palette.surfaceBright

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

		color: root.bgColor
		border {
			color: root.borderColor
			width: root.borderWidth
		}
		radius: root.radius
	}
}
