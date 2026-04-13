import QtQuick
import qs.modules.statusBar.modules
import qs.services

ModuleGroup {
	id: root

	menuOpened: menu.opened
	onClicked: menu.open()

	BarIcon {
		text: "signal_wifi_4_bar"
	}
	BarIcon {
		text: BTService.icon
	}
	BarIcon {
		text: "headphones"
	}

	QuickSettings {
		id: menu
		screen: root.screen
	}
}
