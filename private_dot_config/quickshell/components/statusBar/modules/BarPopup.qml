import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.config

Loader {
	id: root

	active: false
	asynchronous: true

	required property Component component

	readonly property real diff:
		(Config.statusBar.size - Config.statusBar.moduleSize) / 2
	readonly property real diffOffset: diff + Config.statusBar.popupOffset
	readonly property int edge: Config.statusBar.edge
	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	function toggleOpen() {
		if (active) close()
		else open()
	}

	property bool isClosing: false
	function open(): int {
		isClosing = false
		active = true
		x = Qt.binding(function() {
			if (!root.isHorizontal) {
				if (root.edge === Edges.Right) {
				}
				else if (root.edge === Edges.Left) {
					return root.diffOffset + parent.width
				}
			}
			return 0
		})
		y = Qt.binding(function() {
			if (root.isHorizontal) {
				if (root.edge === Edges.Top) {

				}
				else if (root.edge === Edges.Bottom) {

				}
			}
			return 0
		})
		opacity = 1
		return active ? 0 : 3
	}

	function close() {
		x = 0
		y = 0
		opacity = 0
		isClosing = true
	}

	anchors {
		verticalCenter: isHorizontal ? undefined : parent.verticalCenter
		horizontalCenter: isHorizontal ? parent.horizontalCenter : undefined
	}

	Component.onCompleted: close()

	onXChanged: {
		if (root.edge === Edges.Left && x <= 0)
			root.active = false
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
			sourceComponent: root.component
		}
	}
}
