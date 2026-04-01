import QtQuick
import QtQuick.Controls
import qs.widgets
import qs.config
import qs.theme

MenuItem {
	id: root

	property bool selected: false
	property bool vibrant: false
	property int radius: Config.rounding.small
	property real highlightedOpacity: 0.8
	property real dimmedOpacity: 0.6
	property real iconFill: 1.0
	property color regularColor: {
		if (selected) {
			return vibrant ?
				Theme.palette.tertiary
				: Theme.palette.tertiary_container
		} else {
			return vibrant ?
				Theme.palette.tertiary_container
				: Theme.palette.surface_container
		}
	}
	property color highlightedColor: {
		if (selected) {
			return vibrant ?
				Theme.palette.tertiary
				: Theme.palette.tertiary_container
		} else {
			return vibrant ?
				Theme.palette.on_tertiary_container
				: Theme.palette.on_surface
		}
	}
	property color contentColor: {
		if (selected) {
			return vibrant ?
				Theme.palette.on_tertiary
				: Theme.palette.on_tertiary_container
		} else {
			return vibrant ?
				Theme.palette.on_tertiary_container
				: Theme.palette.on_surface
		}
	}

	readonly property alias backgroundRect: backgroundRect

	implicitHeight: 40
	spacing: Config.spacing.smaller

	contentItem: Row {
		id: row
		spacing: root.spacing

		StyledIcon {
			text: root.icon.name
			fill: root.iconFill
			color: root.contentColor
			opacity: root.enabled ? 1.0 : dimmedOpacity
			dimmedOpacity: root.dimmedOpacity
			anchors.verticalCenter: parent.verticalCenter
		}
		StyledText {
			text: root.text
			color: root.contentColor
			opacity: root.enabled ? 1.0 : dimmedOpacity
			width: parent.width -root.arrow.width - row.spacing
			elide: Text.ElideRight
			dimmedOpacity: root.dimmedOpacity
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	background: Rectangle {
		id: backgroundRect
		radius: root.radius
		color: root.regularColor

		Rectangle {
			anchors.fill: parent
			color: root.highlightedColor
			opacity: root.highlighted ? 0.1 : 0.0
			radius: backgroundRect.radius
			Behavior on opacity { M3NumberAnim { data: Anims.current.effects.fast } }
		}
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
