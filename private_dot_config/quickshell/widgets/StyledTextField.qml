import QtQuick
import QtQuick.Controls
import qs.config

TextField {
	id: root

	property int radius: Config.rounding.normal
	property int borderWidth: 2
	property color bgColor: Theme.palette.surfaceBright
	property color borderColorInactive: bgColor
	property color borderColorActive: Theme.palette.accent

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
			color: root.focus ? root.borderColorActive : root.borderColorInactive
			width: root.borderWidth
		}
		radius: root.radius

		Behavior on border.color {
			M3ColorAnim { data: Anims.current.effects.fast }
		}
	}
}
