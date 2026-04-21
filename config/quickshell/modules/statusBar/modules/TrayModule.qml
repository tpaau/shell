pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.SystemTray
import qs.widgets

ModuleGroup {
	id: root

	visible: trayRepeater.count > 0
	enabled: false
	menuOpened: trayRepeater.menuOpened

	Repeater {
		id: trayRepeater
		model: SystemTray.items

		property bool menuOpened: false
		property list<StyledButton> trayButtons: []

		TrayButton {
			parentItem: trayRepeater
			screen: root.screen
			required property SystemTrayItem modelData
			trayItem: modelData
		}
	}
}
