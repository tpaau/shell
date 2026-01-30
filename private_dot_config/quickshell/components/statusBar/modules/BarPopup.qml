pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils

Item {
	id: root

	required property ShellScreen screen

	readonly property int edge: Config.statusBar.edge
	readonly property int dismissThreshold: 50
	readonly property int rounding: Config.rounding.normal
	readonly property Item region: active ? this : null
	readonly property bool active: loader.active
	readonly property int margin: Config.rounding.window + Config.wm.windowGaps - rounding
	readonly property bool isHorizontal: {
		if (edge === Edges.Top || edge === Edges.Bottom) {
			return true
		}
		return false
	}
	onIsHorizontalChanged: close()

	function calcPos() {
		const mappedPos = mapFromItem(loader.anchorItem, x - (width - loader.anchorItem.width) / 2, y - (height - loader.anchorItem.height) / 2)

		if (isHorizontal) {
			x = Utils.clamp(mappedPos.x, width + margin, screen.width - width - margin)
			y = 0
		} else {
			x = 0
			y = Utils.clamp(mappedPos.y, height + margin, screen.height - height - margin)
		}
	}

	function open(component: Component, item: Item): int {
		if (closeTimer.running || xAnim.running || yAnim.running)
			return 1
		if (!item)
			return 4
		const status = Utils.checkComponent(component)
		if (status !== 0)
			return status

		loader.present(component, item)

		return 0
	}

	function close() {
		mouseArea.dismiss()
	}

	anchors {
		top: root.edge === Edges.Top ? parent.top : undefined
		right: root.edge === Edges.Right ? parent.right : undefined
		bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
		left: root.edge === Edges.Left ? parent.left : undefined
		margins: Config.statusBar.size + root.margin
	}

	implicitWidth: mouseArea.width
	implicitHeight: mouseArea.height
	visible: active

	MouseArea {
		id: mouseArea

		propagateComposedEvents: true
		onPressed: mouse => mouse.accepted = false

		function resetPos() {
			x = 0
			y = 0
		}

		function hide() {
			if (root.isHorizontal) {
				const target = height + root.margin + Config.statusBar.size
				if (root.edge === Edges.Top) {
					y = -target
				} else if (root.edge === Edges.Bottom) {
					y = target
				}
			} else {
				const target = width + root.margin + Config.statusBar.size
				if (root.edge === Edges.Right) {
					x = target
				} else if (root.edge === Edges.Left) {
					x = -target
				}
			}
		}

		function dismiss() {
			hide()
			loader.delayedClose()
		}

		drag {
			target: this
			axis: root.isHorizontal ? Drag.YAxis : Drag.XAxis
			filterChildren: true
			maximumX: root.edge === Edges.Left ? root.margin : Number.MAX_VALUE
			minimumX: root.edge === Edges.Right ? -root.margin : -Number.MAX_VALUE
			maximumY: root.edge === Edges.Top ? root.margin : Number.MAX_VALUE
			minimumY: root.edge === Edges.Bottom ? -root.margin : -Number.MAX_VALUE

			onActiveChanged: {
				if (!drag.active) {
					if (Math.max(Math.abs(x), Math.abs(y)) >= root.dismissThreshold) {
						dismiss()
					} else {
						resetPos()
					}
				}
			}
		}

		implicitWidth: wrapper.implicitWidth
		implicitHeight: wrapper.implicitHeight

		Behavior on x {
			enabled: !root.isHorizontal && loader.active

			M3NumberAnim {
				id: xAnim
				data: Anims.current.spatial.fast
			}
		}

		Behavior on y {
			enabled: root.isHorizontal && loader.active

			M3NumberAnim {
				id: yAnim
				data: Anims.current.spatial.fast
			}
		}

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

				function delayedClose() {
					closeTimer.restart()
				}

				function present(component: Component, item: Item) {
					anchorItem = item
					if (active) {
						pendingComponent = component
						mouseArea.dismiss()
					} else {
						mouseArea.hide()
						presentedComponent = component
						pendingComponent = null
						active = true
					}
				}

				onActiveChanged: {
					if (active) {
						Qt.callLater(mouseArea.resetPos)
					} else if (pendingComponent && pendingComponent !== presentedComponent) {
						presentedComponent = pendingComponent
						pendingComponent = null
						mouseArea.hide()
						active = true
					}
				}

				active: false
				visible: status === Loader.Ready && nestedLoader?.status === Loader.Ready
				asynchronous: true

				Timer {
					id: closeTimer
					interval: xAnim.duration
					onTriggered: loader.active = false
				}

				sourceComponent: Rectangle {
					id: rect

					radius: root.rounding
					color: Theme.palette.background
					layer.enabled: true
					layer.samples: Config.quality.layerSamples
					layer.effect: StyledShadow {}

					MarginWrapperManager {
						margin: rect.radius
					}

					Loader {
						id: contentLoader
						anchors.centerIn: parent
						asynchronous: true
						Component.onCompleted: loader.nestedLoader = this
						onStatusChanged: if (status === Loader.Ready)
							root.calcPos()
						sourceComponent: loader.presentedComponent
					}
				}
			}
		}
	}
}
