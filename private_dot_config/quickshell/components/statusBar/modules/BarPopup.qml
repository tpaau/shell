pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils

Item {
	id: root

	readonly property Item region: loader.active ? loader : null
	readonly property bool active: loader.status === Loader.Ready
	readonly property int edge: Config.statusBar.edge
	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	readonly property int dismissThreshold: 50
	readonly property int rounding: Config.rounding.normal

	function calcPos() {
		const mappedPos = mapFromItem(loader.anchorItem, 0,
			y - (height - loader.anchorItem.height) / 2)
		if (isHorizontal) {
			x = mappedPos.y
			y = 0
		}
		else {
			x = 0
			y = mappedPos.y
		}
	}

	function open(component: Component, item: Item): int {
		const status = Utils.checkComponent(component)
		if (status !== 0) return status
		if (!item) return 4

		loader.prepareToPresent(component, item)

		return 0
	}

	anchors {
		top: root.edge === Edges.Top ? parent.top : undefined
		right: root.edge === Edges.Right ? parent.right : undefined
		bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
		left: root.edge === Edges.Left ? parent.left : undefined
		margins: Config.statusBar.size + Config.statusBar.popupOffset
	}

	implicitWidth: mouseArea.width
	implicitHeight: mouseArea.height
	visible: active

	MouseArea {
		id: mouseArea

		propagateComposedEvents: true
		onPressed: (mouse) => mouse.accepted = false

		function resetPos() {
			x = 0
			y = 0
		}

		function dismiss() {
			loader.close()
		}

		drag {
			target: this
			axis: root.isHorizontal ? Drag.YAxis : Drag.XAxis
			filterChildren: true
			maximumX: root.edge === Edges.Left ? Config.statusBar.popupOffset
				: Number.MAX_VALUE
			minimumX: root.edge === Edges.Right ? -Config.statusBar.popupOffset
				: -Number.MAX_VALUE
			maximumY: root.edge === Edges.Top ? Config.statusBar.popupOffset
				: Number.MAX_VALUE
			minimumY: root.edge === Edges.Bottom ? -Config.statusBar.popupOffset
				: -Number.MAX_VALUE

			onActiveChanged: {
				if (!drag.active) {
					if (Math.max(Math.abs(x), Math.abs(y)) >= root.dismissThreshold) {
						dismiss()
					}
					else {
						resetPos()
					}
				}
			}
		}

		implicitWidth: wrapper.implicitWidth
		implicitHeight: wrapper.implicitHeight

		MouseArea {
			id: wrapper

			implicitWidth: loader.implicitWidth
			implicitHeight: loader.implicitHeight

			Loader {
				id: loader

				property Loader nestedLoader: null
				property Component presentedComponent: null
				property Component pendingComponent: null
				property Item anchorItem: null

				// property bool isClosing: false

				function present() {
					// isClosing = false
					active = true
				}

				function close() {
					// isClosing = true
					active = false
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
					if (active) {
						mouseArea.resetPos()
					}
					else if (pendingComponent
					&& pendingComponent !== presentedComponent) {
						presentedComponent = pendingComponent
						pendingComponent = null
						present()
					}
				}

				active: false
				visible: status === Loader.Ready && nestedLoader?.status === Loader.Ready
				asynchronous: true

				Behavior on opacity {
					NumberAnimation {
						duration: Config.animations.durations.popout
						easing.type: Config.animations.easings.popout
					}
				}

				sourceComponent: Rectangle {
					id: rect

					radius: root.rounding
					color: Theme.palette.background
					layer.enabled: true
					layer.samples: Config.quality.layerSamples
					layer.effect: StyledShadow {}

					MarginWrapperManager { margin: rect.radius }

					Loader {
						id: contentLoader
						anchors.centerIn: parent
						asynchronous: true
						Component.onCompleted: loader.nestedLoader = this
						onStatusChanged: if (status === Loader.Ready) root.calcPos()
						sourceComponent: loader.presentedComponent
					}
				}
			}
		}

		Rectangle {
			anchors.fill: parent
			color: "#10ff0000"
		}
	}
}
