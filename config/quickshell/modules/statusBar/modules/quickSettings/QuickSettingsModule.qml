import QtQuick
import qs.widgets
import qs.modules.statusBar.modules

ModuleGroup {
	id: root

	menuOpened: menu.opened
	onClicked: menu.open()

	StyledIcon {
		text: "signal_wifi_4_bar"
	}
	StyledIcon {
		text: "headphones"
	}
	StyledIcon {
		text: "settings"
	}

	QuickSettings {
		id: menu
		screen: root.screen
	}
}
