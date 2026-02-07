pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
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

	readonly property int margin: Config.statusBar.margin
	property bool popupOpen: false

	implicitWidth: isHorizontal ? 0 : Config.statusBar.moduleSize
	implicitHeight: isHorizontal ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
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
				color: Theme.palette.textInverted
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
				color: Theme.palette.textInverted
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: ":"
				visible: root.isHorizontal
				color: Theme.palette.textInverted
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: Qt.formatDateTime(Time.date, "mm")
				color: Theme.palette.textInverted
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
				readonly property alias menuOpen: menu.opened

				implicitWidth: Config.statusBar.moduleSize - 2 * systemTray.spacing
				implicitHeight: Config.statusBar.moduleSize - 2 * systemTray.spacing
				radius: Math.min(width, height) / 3

				onClicked: menu.open()

				QsMenuOpener {
					id: opener
					menu: trayItem.modelData.menu
				}

				StyledMenu {
					id: menu
					onOpenedChanged: root.popupOpen = opened
					transformOrigin: {
						switch (Config.statusBar.edge) {
							case Edges.Top:
								return Popup.TopLeft
							case Edges.Right:
								return Popup.TopRight
							case Edges.Left:
								return Popup.TopLeft
							case Edges.Bottom:
								return Popup.BottomRight
							default:
								Popup.Center
						}
					}

					Repeater {
						id: repeater
						model: opener.children

						Loader {
							id: loader
							asynchronous: true

							required property QsMenuEntry modelData
							// default property alias data: parent.children

							Component {
								id: separatorComp

								Rectangle {
									implicitHeight: 4
									implicitWidth: root.targetWidth - 4 * root.spacing
									anchors.horizontalCenter: parent.horizontalCenter
									radius: height / 2
									color: Theme.palette.surface
								}
							}

							Component {
								id: menuItemComp

								StyledMenuItem {
									onTriggered: {
										root.popupOpen = false
										loader.modelData.triggered()
									}
									text: loader.modelData.text
								}
							}

							sourceComponent: {
								if (loader.modelData.isSeparator) {
									return separatorComp
								} else {
									return menuItemComp
								}
							}
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
