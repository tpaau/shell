pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils

Loader {
	id: root

	property Loader nestedLoader: null
	property Component presentedComponent: null
	property Component pendingComponent: null
	property Item anchorItem: null

	readonly property int edge: Config.statusBar.edge
	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	// property bool isClosing: false
	function open(component: Component, item: Item): int {
		const status = Utils.checkComponent(component)
		if (status !== 0) return status
		if (!item) return 4

		prepareToPresent(component, item)

		return 0
	}

	function present() {
		// isClosing = false
		active = true
	}

	function close() {
		// isClosing = true
		active = false
	}

	function calcPos() {
		const mappedPos = mapFromItem(anchorItem, 0,
			y - (height - anchorItem.height) / 2)
		if (root.isHorizontal) {
			x = mappedPos.y
		}
		else {
			y = mappedPos.y
		}
	}

	function prepareToPresent(component: Component, item: Item) {
		anchorItem = item
		if (active) {
			pendingComponent = component
			close()
		}
		else {
			presentedComponent = component
			present()
		}
	}

	onActiveChanged: {
		if (!active && pendingComponent && pendingComponent !== presentedComponent) {
			presentedComponent = pendingComponent
			pendingComponent = null
			present()
		}
	}

	active: false
	visible: status === Loader.Ready && nestedLoader?.status === Loader.Ready
	asynchronous: true

	anchors {
		top: root.edge === Edges.Top ? parent.top : undefined
		right: root.edge === Edges.Right ? parent.right : undefined
		bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
		left: root.edge === Edges.Left ? parent.left : undefined
		margins: Config.statusBar.size + Config.statusBar.popupOffset
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
			Component.onCompleted: root.nestedLoader = this
			onStatusChanged: if (status === Loader.Ready) root.calcPos()
			sourceComponent: root.presentedComponent
		}
	}

	MouseArea {
		anchors.fill: parent
		z: 1

		propagateComposedEvents: true
		onPressed: (mouse) => {
			mouse.accepted = false
			console.warn("Pressed!")
		}

		drag {
			axis: root.isHorizontal ? Drag.YAxis : Drag.XAxis
			target: root
			onActiveChanged: {
				console.warn(`active: ${active}`)
			}
		}

		Rectangle {
			anchors.fill: parent
			color: "#10ff0000"
		}
	}
}
