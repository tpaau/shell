pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.modules.statusBar.modules.quickSettings

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
		clip: true
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

		readonly property int availableSize: BarConfig.isHorizontal ?
			(grid.width - modulesCenter.implicitWidth - implicitWidth) / 2 - 4 * BarConfig.properties.spacing
			: (grid.height - modulesCenter.implicitHeight - implicitHeight) / 2 - 4 * BarConfig.properties.spacing

		Repeater {
			id: repeater
			model: {
				let modules = []
				let windowTitleFound = false
				for (const module of moduleGrid.model) {
					if (modules.find(m => m.name == module)) {
						console.warn(`Found duplicate module "${module}". Please remove it.`)
						continue
					}
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
					roleValue: "quick-settings"
					delegate: QuickSettingsModule {
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
				DelegateChoice {
					roleValue: "window-title"
					delegate: WindowTitle {
						repeater: repeater
						screen: root.screen
						availableSize: moduleGrid.availableSize
					}
				}
				DelegateChoice {
					roleValue: "caffeine"
					delegate: CaffeineModule {
						repeater: repeater
						screen: root.screen
					}
				}
				DelegateChoice {
					roleValue: "notifications"
					delegate: NotificationsModule {
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
			implicitWidth: BarConfig.isHorizontal ?
				Math.min(
					Math.max(modulesTopOrLeft.implicitWidth, modulesBottomOrRight.implicitWidth),
					(grid.width - modulesCenter.implicitWidth) / 2 - 4 * BarConfig.properties.spacing
				)
				: modulesTopOrLeft.implicitWidth
			implicitHeight: BarConfig.isHorizontal ?
				modulesTopOrLeft.implicitHeight
				: Math.min(
					Math.max(modulesTopOrLeft.implicitHeight, modulesBottomOrRight.implicitHeight),
					(grid.height - modulesCenter.implicitHeight) / 2 - 4 * BarConfig.properties.spacing
				)
			clip: true
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
				Math.min(
					Math.max(modulesTopOrLeft.implicitWidth, modulesBottomOrRight.implicitWidth),
					(grid.width - modulesCenter.implicitWidth) / 2 - 4 * BarConfig.properties.spacing
				)
				: modulesTopOrLeft.implicitWidth
			implicitHeight: BarConfig.isHorizontal ?
				modulesTopOrLeft.implicitHeight
				: Math.min(
					Math.max(modulesTopOrLeft.implicitHeight, modulesBottomOrRight.implicitHeight),
					(grid.height - modulesCenter.implicitHeight) / 2 - 4 * BarConfig.properties.spacing
				)
			clip: true
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
	}
}
