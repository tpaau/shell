pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.quickSettings
import qs.widgets

Singleton {
	id: root

	signal closePopups()
	signal closeToasts()
	signal displayIndicatorToast(comp: Component)

	signal openSessionManagement()
	signal closeSessionManagement()
	signal toggleSessionManagement()

	signal toggleLauncher()
	signal closeLauncher()

	property list<QuickSettings> quickSettingsList: []
	property list<StyledMenu> batteryMenuList: []

	IpcHandler {
		target: "sessionManagement"

		function open() {
			root.openSessionManagement()
		}
		function close() {
			root.closeSessionManagement()
		}
		function toggleOpen() {
			root.toggleSessionManagement()
		}
	}

	IpcHandler {
		target: "floatingContent"

		function toggleLauncher() {
			root.toggleLauncher()
		}
		function close() {
			root.closeLauncher()
		}
	}
}
