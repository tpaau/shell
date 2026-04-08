import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.modules.statusBar
import qs.modules.statusBar.modules

ModuleGroup {
	id: root

	menuOpened: menu.opened
	onClicked: menu.open()

	BarIcon {
		text: "signal_wifi_4_bar"
	}
	BarIcon {
		text: "headphones"
	}
	BarIcon {
		text: "settings"
	}

	QuickSettings {
		id: menu
		screen: root.screen
	}
}
