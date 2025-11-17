pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.config

Loader {
	id: root

	active: false
	asynchronous: true

	anchors {
		verticalCenter: parent.verticalCenter
		horizontalCenter: parent.horizontalCenter
	}

	required property Component component

	property bool isClosing: false
	function open(component: Component): int {
		isClosing = false
		active = true
	}

	function close() {
		isClosing = true
	}

	readonly property int edge: Config.statusBar.edge
	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	sourceComponent: PopoutShape {
		anchors {
			top: root.edge === Edges.Top ? parent.top : undefined
			right: root.edge === Edges.Right ? parent.right : undefined
			bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
			left: root.edge === Edges.Left ? parent.left : undefined
			verticalCenter: root.isHorizontal ? undefined : parent.verticalCenter
			horizontalCenter: root.isHorizontal ? parent.horizontalCenter : undefined
			topMargin: root.edge === Edges.Top ? Config.statusBar.size - 1 : 0
			rightMargin: root.edge === Edges.Right ? Config.statusBar.size - 1 : 0
			bottomMargin: root.edge === Edges.Bottom ? Config.statusBar.size - 1 : 0
			leftMargin: root.edge === Edges.Left ? Config.statusBar.size - 1 : 0
		}
		alignment: {
			switch(root.edge) {
				case Edges.Top:
					return PopoutAlignment.top
				case Edges.Right:
					return PopoutAlignment.right
				case Edges.Bottom:
					return PopoutAlignment.bottom
				case Edges.Left:
					return PopoutAlignment.left
			}
		}

		implicitWidth: root.isHorizontal ? contentLoader.width + 4 * radius : 0
		implicitHeight: root.isHorizontal ? 0 : contentLoader.height + 4 * radius

		Component.onCompleted: {
			if (root.isHorizontal) {
				implicitHeight = Qt.binding(function() {
					return root.isClosing ?
						0 : contentLoader.width + 2 * radius
				})
			}
			else {
				implicitWidth = Qt.binding(function() {
					return root.isClosing ?
						0 : contentLoader.width + 2 * radius
				})
			}
		}

		Behavior on implicitWidth {
			enabled: !root.isHorizontal
			NumberAnimation {
				duration: Config.animations.durations.popout
				easing.type: Config.animations.easings.popout
			}
		}

		Behavior on implicitHeight {
			enabled: root.isHorizontal
			NumberAnimation {
				duration: Config.animations.durations.popout
				easing.type: Config.animations.easings.popout
			}
		}

		Loader {
			id: contentLoader
			anchors.centerIn: parent
			asynchronous: true
			sourceComponent: root.component
		}
	}
}
