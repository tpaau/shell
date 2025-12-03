pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.components.bottomDrawer.content
import qs.widgets
import qs.utils
import qs.config

Loader {
	id: root

	readonly property Item region: status === Loader.Ready ? this : null

	readonly property bool exclusiveFocus: active ?
		presentedComponent === appLauncher
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

	function close() {
		isClosing = true
	}

	IpcHandler {
		target: "bottomDrawer"

		function toggleAppLauncher() {
			root.active ? root.close() : root.open(appLauncher)
		}

		function close() { root.close() }
	}

	Component {
		id: appLauncher
		AppLauncher {}
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

		onImplicitHeightChanged: if (implicitHeight <= 0) root.active = false

		Behavior on implicitHeight {
			M3NumberAnim { data: Config.anims.current.spatial.fast }
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
