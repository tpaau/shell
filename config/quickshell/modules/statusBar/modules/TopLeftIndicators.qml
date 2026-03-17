pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.widgets
import qs.services
import qs.config

GridLayout {
	id: root

	required property bool isHorizontal

	readonly property alias menuOpened: repeater.menuOpened

	implicitWidth: isHorizontal ? 0 : Config.statusBar.size - 2 * Config.statusBar.padding
	implicitHeight: isHorizontal ? Config.statusBar.size - 2 * Config.statusBar.padding : 0

	columnSpacing: Config.statusBar.spacing / 2
	rowSpacing: Config.statusBar.spacing / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	ModuleGroup {
		id: clock

		topOrLeft: null
		bottomOrRight: systemTray
		isHorizontal: root.isHorizontal

		GridLayout {
			rowSpacing: 0
			columnSpacing: 0
			flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

			StyledText {
				text: Qt.formatDateTime(Time.date, "hh")
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: ":"
				visible: root.isHorizontal
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: Qt.formatDateTime(Time.date, "mm")
				font.weight: Config.font.weight.heavy
			}
		}
	}

	ModuleGroup {
		id: systemTray
		topOrLeft: clock
		bottomOrRight: null
		isHorizontal: root.isHorizontal
		visible: repeater.count > 0

		Repeater {
			id: repeater
			model: SystemTray.items

			property bool menuOpened: false
			property list<StyledButton> trayButtons: []

			TrayButton {
				parentItem: repeater
				required property SystemTrayItem modelData
				trayItem: modelData
			}
		}
	}
}
