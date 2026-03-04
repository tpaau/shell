pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.widgets
import qs.utils
import qs.services
import qs.services.config
import qs.services.config.theme

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

			property bool menuOpened: false
			property list<BarButton> trayButtons: []

			BarButton {
				id: trayButton

				required property SystemTrayItem modelData
				readonly property bool menuOpened: trayMenu.opened

				onClicked: trayMenu.open()
				Component.onCompleted: repeater.trayButtons.push(this)
				Component.onDestruction: repeater.menuOpened = false

				Component {
					id: submenuComponent

					TrayMenu {
						id: submenu

						required property QsMenuEntry modelData

						model: opener.children
						enabled: modelData?.enabled ?? false
						title: modelData?.text ?? ""

						QsMenuOpener {
							id: opener
							menu: submenu.modelData ?? null
						}
					}
				}

				component TrayMenu: BarMenu {
					id: trayMenu
					implicitWidth: 220

					onOpenedChanged: {
						if (opened) repeater.menuOpened = true
						else repeater.menuOpened = false
					}

					property alias model: instantiator.model

					Instantiator {
						id: instantiator

						onObjectAdded: (index, object) => {
							if (object instanceof Menu)
								trayMenu.insertMenu(index, object)
							else
								trayMenu.insertItem(index, object)
						}

						onObjectRemoved: (index, object) => {
							if (object instanceof Menu)
								trayMenu.removeMenu(object)
							else
								trayMenu.removeItem(object)
						}

						delegate: DelegateChooser {
							role: "isSeparator"

							DelegateChoice {
								roleValue: false

								delegate: DelegateChooser {
									role: "hasChildren"

									DelegateChoice {
										roleValue: false

										delegate: StyledMenuItem {
											id: menuItem

											required property QsMenuEntry modelData

											text: modelData?.text ?? ""
											enabled: modelData?.enabled ?? false
											checkable: modelData?.enabled ?? false
											onClicked: modelData?.triggered()
											highlightedColor: Theme.palette.surface_container

											indicator: Loader {
												sourceComponent: Rectangle {
													implicitHeight: 10
													color: "red"
												}
											}
										}
									}
									DelegateChoice {
										roleValue: true
										delegate: submenuComponent
									}
								}
							}
							DelegateChoice {
								roleValue: true

								delegate: Rectangle {
									implicitHeight: 4
									color: Theme.palette.surface_container_low
									radius: height / 2
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

				TrayMenu {
					id: trayMenu
					model: opener.children.values
				}
			}
		}
	}
}
