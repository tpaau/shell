pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray
import qs.modules.statusBar
import qs.widgets

StyledButton {
	id: root

	required property SystemTrayItem trayItem
	required property Item parentItem
	readonly property bool menuOpened: trayMenu.opened

	implicitWidth: BarConfig.properties.size - 4 * BarConfig.properties.padding
	implicitHeight: BarConfig.properties.size - 4 * BarConfig.properties.padding
	radius: (BarConfig.properties.size - 2 * BarConfig.properties.padding) / 2
	theme: StyledButton.Theme.SurfaceContainer

	onClicked: trayMenu.open()
	Component.onCompleted: parentItem.trayButtons.push(this)
	Component.onDestruction: if (parentItem) parentItem.menuOpened = false

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

	Image {
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
		fillMode: Image.PreserveAspectFit
		sourceSize.width: width
		sourceSize.height: height
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
