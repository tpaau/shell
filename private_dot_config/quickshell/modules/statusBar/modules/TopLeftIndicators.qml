pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.widgets
import qs.utils
import qs.services
import qs.services.config

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
		id: osIconGroup

		topOrLeft: null
		bottomOrRight: clock
		isHorizontal: root.isHorizontal

		Item {
			implicitWidth: osIcon.width
			implicitHeight: osIcon.width

			StyledText {
				id: osIcon
				anchors.centerIn: parent
				font.pixelSize: Config.icons.size.regular
				text: Icons.osIcon
			}
		}
	}

	ModuleGroup {
		id: clock

		topOrLeft: osIconGroup
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

			readonly property bool menuOpened: {
				for (const trayButton of trayButtons) {
					if (trayButton?.menuOpened) return true
				}
				return false
			}
			property list<BarButton> trayButtons: []

			BarButton {
				id: trayButton

				required property SystemTrayItem modelData
				readonly property bool menuOpened: trayMenu.opened

				onClicked: trayMenu.open()
				Component.onCompleted: repeater.trayButtons.push(this)

				IconImage {
					id: icon

					asynchronous: true
					anchors {
						fill: parent
						margins: 3
					}
					mipmap: true

					source: {
						if (!trayButton.modelData) return ""
						let icon = trayButton.modelData.icon
						if (icon.includes("?path=")) {
							const [name, path] = icon.split("?path=")
							icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`
						}
						return icon
					}
				}

				QsMenuOpener {
					id: opener
					menu: trayButton.modelData?.menu ?? null
				}

				BarMenu {
					id: trayMenu

					Repeater {
						model: opener.children

						StyledMenuItem {
							required property QsMenuEntry modelData

							text: modelData?.text
							onClicked: modelData.triggered()
							enabled: !modelData?.isSeparator
						}
					}
				}
			}
		}
	}
}
