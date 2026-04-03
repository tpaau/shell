pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.widgets
import qs.config

StyledButton {
	id: root

	required property SystemTrayItem trayItem
	required property Item parentItem
	readonly property bool menuOpened: trayMenu.opened

	implicitWidth: Config.statusBar.size - 4 * Config.statusBar.padding
	implicitHeight: Config.statusBar.size - 4 * Config.statusBar.padding
	radius: (Config.statusBar.size - 2 * Config.statusBar.padding) / 2
	theme: StyledButton.Theme.SurfaceContainer

	onClicked: trayMenu.open()
	Component.onCompleted: parentItem.trayButtons.push(this)
	Component.onDestruction: parentItem.menuOpened = false

	Component {
		id: submenuComponent

		TrayMenu {
			id: submenu

			required property QsMenuEntry modelData

			model: opener.children
			enabled: modelData?.enabled ?? false
			title: modelData?.text ?? ""
			color: trayMenu.color
			isSubmenu: true

			QsMenuOpener {
				id: opener
				menu: submenu.modelData ?? null
			}
		}
	}

	IconImage {
		id: icon

		asynchronous: true
		anchors {
			fill: parent
			margins: 3
		}
		mipmap: true

		source: {
			if (!root.trayItem) return ""
			let icon = root.trayItem.icon
			if (icon.includes("?path=")) {
				const [name, path] = icon.split("?path=")
				icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`
			}
			return icon
		}
	}

	QsMenuOpener {
		id: opener
		menu: root.trayItem?.menu ?? null
	}

	TrayMenu {
		id: trayMenu
		parentItem: root.parentItem
		submenuComponent: submenuComponent
		model: opener.children.values
	}
}
