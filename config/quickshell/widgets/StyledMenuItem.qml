import QtQuick
import QtQuick.Controls
import qs.widgets
import qs.config
import qs.theme

MenuItem {
	id: root

	property int radius: Config.rounding.small
	property real highlightedOpacity: 0.8
	property real dimmedOpacity: 0.6
	property real iconFill: 1.0
	property color highlightedColor: Theme.palette.surface_container_highest

	implicitHeight: 40
	spacing: Config.spacing.smaller

	contentItem: Row {
		id: row
		spacing: root.spacing

		StyledIcon {
			text: root.icon.name
			fill: root.iconFill
			theme: root.enabled ? StyledIcon.Theme.Regular : StyledIcon.Theme.RegularDim
			dimmedOpacity: root.dimmedOpacity
			anchors.verticalCenter: parent.verticalCenter
		}
		StyledText {
			text: root.text
			theme: root.enabled ? StyledText.Theme.Regular : StyledText.Theme.RegularDim
			width: parent.width -root.arrow.width - row.spacing
			elide: Text.ElideRight
			dimmedOpacity: root.dimmedOpacity
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	background: Rectangle {
		radius: root.radius
		color: Qt.alpha(root.highlightedColor, root.highlighted ? root.highlighted : 0)
		Behavior on color { M3ColorAnim { data: Anims.current.effects.fast } }
	}

    arrow: StyledIcon {
		x: root.mirrored ? root.leftPadding : root.width - width - root.rightPadding
		y: root.topPadding + (root.availableHeight - height) / 2
		text: "keyboard_arrow_right"

		fill: 1
		visible: root.subMenu
		color: root.enabled ? Theme.palette.on_surface : Qt.alpha(Theme.palette.on_surface, root.dimmedOpacity)
    }
}
