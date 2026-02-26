import QtQuick
import QtQuick.Controls
import qs.services.config

TextField {
	id: root

	property int radius: Config.rounding.normal
	property int borderWidth: 2
	property color bgColor: Theme.palette.surface_container_low
	property color borderColorInactive: bgColor
	property color borderColorActive: Theme.palette.primary_fixed_dim

	property alias bgRect: bgRect

	color: Theme.palette.primary_fixed
	placeholderTextColor: Theme.palette.primary_fixed_dim
	padding: Config.spacing.large
	font.pixelSize: Config.font.size.large
	selectionColor: Theme.palette.primary_fixed
	selectedTextColor: Theme.palette.surface

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
