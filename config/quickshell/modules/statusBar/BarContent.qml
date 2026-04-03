pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.config
import qs.services

Item {
	id: root
	anchors.fill: parent

	required property ShellScreen screen

	readonly property bool menuOpened:
		modulesTopOrLeft.menuOpened
		|| modulesCenter.menuOpened
		|| modulesBottomOrRight.menuOpened

	component ModuleGrid: GridLayout {
		rowSpacing: BarConfig.properties.spacing
		columnSpacing: BarConfig.properties.spacing
		rows: 1
		columns: 1
		flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
			: GridLayout.LeftToRight
	}

	component BarModuleGroup: ModuleGrid {
		id: moduleGrid
		required property list<string> model
		rowSpacing: Math.floor(BarConfig.properties.spacing / 2)
		columnSpacing: Math.floor(BarConfig.properties.spacing / 2)

		readonly property bool menuOpened: {
			for (const child of children) {
				if (child.menuOpened) return true
			}
			return false
		}

		Repeater {
			id: repeater
			model: {
				let modules = []
				for (const module of moduleGrid.model) {
					modules.push({
						name: module
					})
				}
				return modules
			}

			DelegateChooser {
				role: "name"

				DelegateChoice {
					roleValue: "clock"
					delegate: ClockModule {
						repeater: repeater
						screen: root.screen
					}
				}
				DelegateChoice {
					roleValue: "tray"
					delegate: TrayModule {
						repeater: repeater
						screen: root.screen
					}
				}
				DelegateChoice {
					roleValue: "workspaces"
					delegate: WorkspacesModule {
						repeater: repeater
						screen: root.screen
					}
				}
				DelegateChoice {
					roleValue: "connectivity"
					delegate: Connectivity {
						repeater: repeater
						screen: root.screen
					}
				}
				DelegateChoice {
					roleValue: "indicators"
					delegate: Indicators {
						repeater: repeater
						screen: root.screen
					}
				}
				DelegateChoice {
					roleValue: "battery"
					delegate: BatteryModule {
						repeater: repeater
						screen: root.screen
					}
				}
				DelegateChoice {
					roleValue: "date"
					delegate: DateModule {
						repeater: repeater
						screen: root.screen
					}
				}
			}
		}
	}

	ModuleGrid {
		id: grid

		anchors {
			fill: parent
			margins: BarConfig.properties.padding
		}

		rowSpacing: 4 * BarConfig.properties.spacing
		columnSpacing: 4 * BarConfig.properties.spacing

		Item {
			visible: !BarConfig.properties.fill
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
		Item {
			implicitWidth: BarConfig.isHorizontal ?
				Math.max(modulesTopOrLeft.implicitWidth, modulesBottomOrRight.implicitWidth)
				: modulesTopOrLeft.implicitWidth
			implicitHeight: BarConfig.isHorizontal ?
				modulesTopOrLeft.implicitHeight
				: Math.max(modulesTopOrLeft.implicitHeight, modulesBottomOrRight.implicitHeight)
			Layout.alignment: BarConfig.isHorizontal ? Qt.AlignLeft : Qt.AlignTop
			BarModuleGroup {
				id: modulesTopOrLeft
				anchors {
					top: parent.top
					left: parent.left
				}
				model: BarConfig.modulesTopOrLeft
			}
		}
		BarModuleGroup {
			id: modulesCenter
			model: BarConfig.modulesCenter
			Layout.alignment: Qt.AlignCenter
		}
		Item {
			implicitWidth: BarConfig.isHorizontal ?
				Math.max(modulesBottomOrRight.implicitWidth, modulesTopOrLeft.implicitWidth)
				: modulesBottomOrRight.implicitWidth
			implicitHeight: BarConfig.isHorizontal ?
				modulesBottomOrRight.implicitHeight
				: Math.max(modulesBottomOrRight.implicitHeight, modulesTopOrLeft.implicitHeight)
			Layout.alignment: BarConfig.isHorizontal ? Qt.AlignRight : Qt.AlignBottom
			BarModuleGroup {
				id: modulesBottomOrRight
				anchors {
					right: parent.right
					bottom: parent.bottom
				}
				model: BarConfig.modulesBottomOrRight
			}
		}
		Item {
			visible: !BarConfig.properties.fill
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}
}
