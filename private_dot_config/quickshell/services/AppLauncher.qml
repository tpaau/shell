pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton {
	function close() { ipc.close() }

	IpcHandler {
		id: ipc

		target: "appLauncher"
		function open(): int {
			return ShellIpc.bottomContent.open(appDrawer)
		}
		function close() {
			ShellIpc.bottomContent.close()
		}
		function toggleOpen(): int {
			if (ShellIpc.bottomContent.active) {
				ShellIpc.bottomContent.close()
			}
			else {
				return ShellIpc.bottomContent.open(appDrawer)
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
