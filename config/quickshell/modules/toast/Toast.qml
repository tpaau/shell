pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.theme
import qs.config
import qs.utils
import qs.services

// Displays components in a toast at the bottom of the screen.
Loader {
	id: root

	readonly property int padding: Config.spacing.small
	readonly property M3AnimData animData: Anims.current.effects.regular
	readonly property bool busy: active || openAnim.running

	property Component presentedComponent: null
	property Component pendingComponent: null

	function open(component: Component): int {
		const status = Utils.checkComponent(component)
		if (status !== 0) return status
		if (active) {
			pendingComponent = component
			close()
		} else {
			presentedComponent = component
			active = true
			openAnim.restart()
		}

		return 0
	}

	function openIfNotBusy(component: Component): int {
		if (busy) return 4
		else return open(component)
	}

	function close(): int {
		if (!active) return 1
		closeAnim.restart()
		return 0
	}

	active: false
	opacity: 0
	layer.enabled: true
	layer.effect: StyledShadow {}
	anchors {
		bottom: parent.bottom
		horizontalCenter: parent.horizontalCenter
	}
	onActiveChanged: if (!active && pendingComponent) {
		open(pendingComponent)
	}
	Component.onCompleted: Ipc.toast = this

	ParallelAnimation {
		id: openAnim

		M3NumberAnim {
			data: root.animData
			target: root
			property: "anchors.bottomMargin"
			from: -root.height
			to: Utils.marginFromEdge(Edges.Bottom)
		}
		M3NumberAnim {
			data: root.animData
			target: root
			property: "opacity"
			from: 0.0
			to: 1.0
		}
	}

	ParallelAnimation {
		id: closeAnim

		M3NumberAnim {
			data: root.animData
			target: root
			property: "anchors.bottomMargin"
			from: root.anchors.bottomMargin
			to: -root.height
		}
		M3NumberAnim {
			data: root.animData
			target: root
			property: "opacity"
			from: 1.0
			to: 0.0
		}

		onFinished: root.active = false
	}

	sourceComponent: Rectangle {
		color: Theme.palette.surface
		radius: Math.min(width, height) / 2
		implicitWidth: loader.implicitWidth + 2 * root.padding
			+ (Math.min(loader.implicitWidth, loader.implicitHeight) + 2 * padding) / 4
		implicitHeight: loader.implicitHeight + 2 * root.padding

		Loader {
			id: loader
			anchors.centerIn: parent
			sourceComponent: root.presentedComponent
		}
	}
}
