pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
	id: root

	property int itemSize: 32

	Repeater {
		id: repeater
		model: SystemTray.items

		TrayItem {
			itemSize: root.itemSize
		}
	}
}
