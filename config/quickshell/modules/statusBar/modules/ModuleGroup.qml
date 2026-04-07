import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.statusBar
import qs.theme

Rectangle {
	id: root

	required property Repeater repeater
	required property ShellScreen screen
	required property int index

	property var topOrLeft: null
	property var bottomOrRight: null
	Component.onCompleted: {
		const topOrLeftModule = repeater.itemAt(index - 1)
		if (topOrLeftModule) {
			topOrLeft = topOrLeftModule
			if (topOrLeft instanceof ModuleGroup && !topOrLeft.bottomOrRight) {
				topOrLeft.bottomOrRight = this
			}
		}
		const bottomOrRightModule = repeater.itemAt(index + 1)
		if (bottomOrRightModule) {
			bottomOrRight = bottomOrRightModule
			if (bottomOrRight instanceof ModuleGroup && !bottomOrRight.topOrLeft) {
				bottomOrRight.topOrLeft = this
			}
		}
	}

	readonly property alias layout: layout
	readonly property int radiusSmall: BarConfig.properties.spacing / 2
	readonly property int radiusLarge: Math.max(width, height) / 2

	property int spacing: BarConfig.properties.spacing

	default property alias content: layout.data
	readonly property alias visibleChildren: layout.visibleChildren

	// Whether other module groups should visually "connect" to this group
	property bool connected: visible
	// Whether the status bar should receive fullscreen focus due to a menu
	// being opened in this module
	property bool menuOpened: false

	implicitWidth: BarConfig.isHorizontal ?
		layout.visibleChildren > 0 ?
			layout.width + 2 * spacing : 0
		: BarConfig.properties.size - 2 * BarConfig.properties.padding
	implicitHeight: BarConfig.isHorizontal ?
		BarConfig.properties.size - 2 * BarConfig.properties.padding
		: layout.visibleChildren > 0 ?
			layout.height + 2 * spacing : 0

	color: Theme.palette.surface_container_low
	topRightRadius: connected ?
		BarConfig.isHorizontal ?
			bottomOrRight && bottomOrRight.connected ? radiusSmall : radiusLarge
			: topOrLeft && topOrLeft.connected ? radiusSmall : radiusLarge
		: radiusLarge
	topLeftRadius: connected ?
		topOrLeft && topOrLeft.connected ? radiusSmall : radiusLarge
		: radiusLarge
	bottomRightRadius: connected ?
		bottomOrRight && bottomOrRight.connected ? radiusSmall : radiusLarge
		: radiusLarge
	bottomLeftRadius: connected ?
		BarConfig.isHorizontal ?
			topOrLeft && topOrLeft.connected ? radiusSmall : radiusLarge
			: bottomOrRight && bottomOrRight.connected ? radiusSmall : radiusLarge
		: radiusLarge

	GridLayout {
		id: layout
		anchors.centerIn: parent
		rowSpacing: root.spacing
		columnSpacing: root.spacing
		rows: 1
		columns: 1
		flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
			: GridLayout.LeftToRight

		readonly property int visibleChildren: {
			let count = 0
			for (const child of children) {
				if (child && child.visible) count++
			}
			return count
		}
	}
}
