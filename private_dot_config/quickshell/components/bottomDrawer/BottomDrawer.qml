pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.components.bottomDrawer.content
import qs.widgets
import qs.utils
import qs.config

// Displays components in a drawer/popout at the bottom of the screen.
//
// Due to the animations on this thing, the items inside of it *should not*
// change their height during runtime. It will cause the content to briefly go
// off-screen and/or snap move upwards.
Loader {
	id: root

	readonly property Item region: status === Loader.Ready ? this : null

	readonly property bool exclusiveFocus: active ?
		presentedComponent === launcher
		: false

	anchors {
		bottom: parent.bottom
		horizontalCenter: parent.horizontalCenter
	}

	asynchronous: true
	active: false

	property bool isClosing: false
	property Component presentedComponent: null
	function open(component: Component): int {
		const status = Utils.checkComponent(component)
		if (status !== 0) return status

		isClosing = false
		presentedComponent = component
		active = true

		return 0
	}

	function close(): int {
		if (!active) {
			return 1
		}
		isClosing = true
	}

	IpcHandler {
		target: "bottomDrawer"

		function toggleLauncher(): int {
			return root.active ? root.close() : root.open(launcher)
		}
		function close(): int { return root.close() }
	}

	Component {
		id: launcher
		Launcher {
			drawer: root
		}
	}

	sourceComponent: PopoutShape {
		id: popout

		anchors {
			bottom: parent.bottom
			bottomMargin: -1
		}

		alignment: PopoutAlignment.bottom

		implicitWidth: loader.width + 4 * radius
		implicitHeight: root.isClosing ? 0 : loader.height + 2 * radius
		onHeightChanged: if (implicitHeight <= 0) root.active = false

		visible: loader.status === Loader.Ready

		Behavior on implicitHeight {
			M3NumberAnim {
				data: Anims.current.spatial.fast
			}
		}

		Item {
			id: wrapper

			anchors {
				fill: parent
				topMargin: popout.radius
				bottomMargin: popout.radius
				rightMargin: 1 * popout.radius
				leftMargin: 1 * popout.radius
			}

			Loader {
				id: loader

				anchors {
					top: parent.top
					horizontalCenter: parent.horizontalCenter
				}

				asynchronous: true
				active: true

				sourceComponent: root.presentedComponent
			}
		}
	}
}
