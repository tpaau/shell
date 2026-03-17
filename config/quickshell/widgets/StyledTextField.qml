import QtQuick
import QtQuick.Controls
import qs.config
import qs.theme

TextField {
	id: root

	property real inactiveOpacity: 0.7
	property color bgColor: Theme.palette.surface_container_low
	property color borderColorInactive: bgColor
	property color borderColorActive: Theme.palette.on_surface
	property color textColor: Theme.palette.on_surface
	property int radius: Config.rounding.normal
	property int borderWidth: 2

	property alias bgRect: bgRect

	color: borderColorActive
	placeholderTextColor: Qt.alpha(color, inactiveOpacity)
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
