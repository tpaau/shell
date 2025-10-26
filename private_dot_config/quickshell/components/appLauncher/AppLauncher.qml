import QtQuick
import Quickshell.Io
import qs.components.bottomContent

Item {
	id: root
	function close() { ipc.close() }

	required property BottomContent bottomContent

	IpcHandler {
		id: ipc

		target: "appLauncher"
		function open(): int {
			return root.bottomContent.open(appDrawer)
		}
		function close() {
			root.bottomContent.close()
		}
		function toggleOpen(): int {
			if (root.bottomContent.active) {
				root.bottomContent.close()
			}
			else {
				return root.bottomContent.open(appDrawer)
			}
			return 0
		}
	}

	Component {
		id: appDrawer
		Rectangle {
			color: "red"
			implicitWidth: 100
			implicitHeight: 100
		}
	}
}
