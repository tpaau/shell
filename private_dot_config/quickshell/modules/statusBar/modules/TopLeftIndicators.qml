pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.widgets
import qs.config
import qs.utils
import qs.services

GridLayout {
	id: root

	required property bool isHorizontal
	required property BarPopup popup

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

			StyledButton {
				id: trayItem

				required property SystemTrayItem modelData

				implicitWidth: Math.min(systemTray.width, systemTray.height)
					- Config.statusBar.padding
				implicitHeight: Math.min(systemTray.width, systemTray.height)
					- Config.statusBar.padding
				radius: Math.min(width, height) / 3
				theme: StyledButton.Theme.Surface

				onClicked: root.popup.open(trayMenuContent, this)

				Component {
					id: trayMenuContent

					StyledQsMenu {
						menu: trayItem.modelData.menu
						property bool firstChange: true
						onMenuChanged: {
							if (firstChange) firstChange = false
							else root.popup.close()
						}
					}
				}

				IconImage {
					id: icon

					asynchronous: true
					anchors {
						fill: parent
						margins: 2
					}
					mipmap: true

					source: {
						let icon = trayItem.modelData.icon
						if (icon.includes("?path=")) {
							const [name, path] = icon.split("?path=")
							icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`
						}
						return icon
					}
				}
			}
		}
	}
}
