pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils

Loader {
	id: root

	property Component presentedComponent: null
	property Component pendingComponent: null
	property Item anchorItem: null
	property Item pendingAnchorItem: null

	readonly property int edge: Config.statusBar.edge
	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	y: anchorItem ? -parent.mapToItem(anchorItem, anchorItem.x, anchorItem.y).y : 0
	property bool isClosing: false
	function open(component: Component, item: Item): int {
		const status = Utils.checkComponent(component)
		if (status !== 0) return status
		if (!item) return 4

		pendingComponent = component
		pendingAnchorItem = item

		console.warn(mapToItem(item, 0, 0))

		if (!active) {
			presentedComponent = pendingComponent
			anchorItem = pendingAnchorItem
			isClosing = false
			active = true
		}
		else close()

		return active ? 0 : 1
	}

	function close() {
		// isClosing = true
		active = false
	}

	onActiveChanged: {
		if(!active && pendingComponent) presentedComponent = pendingComponent
	}

	active: false
	asynchronous: true

	anchors {
		top: root.edge === Edges.Top ? parent.top : undefined
		right: root.edge === Edges.Right ? parent.right : undefined
		bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
		left: root.edge === Edges.Left ? parent.left : undefined
		margins: Config.statusBar.size + Config.statusBar.popupOffset
	}

	Behavior on x {
		NumberAnimation {
			duration: Config.animations.durations.popout
			easing.type: Config.animations.easings.popout
		}
	}

	Behavior on y {
		NumberAnimation {
			duration: Config.animations.durations.popout
			easing.type: Config.animations.easings.popout
		}
	}

	Behavior on opacity {
		NumberAnimation {
			duration: Config.animations.durations.popout
			easing.type: Config.animations.easings.popout
		}
	}

	sourceComponent: Rectangle {
		id: rect

		radius: Config.rounding.normal
		color: Theme.palette.background
		layer.enabled: true
		layer.samples: Config.quality.layerSamples
		layer.effect: StyledShadow {}

		MarginWrapperManager { margin: rect.radius }

		Loader {
			id: contentLoader
			anchors.centerIn: parent
			asynchronous: true
			sourceComponent: root.presentedComponent
		}
	}
}
