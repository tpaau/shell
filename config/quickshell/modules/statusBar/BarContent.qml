pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.config

Item {
	id: root
	anchors.fill: parent

	required property ShellScreen screen

	readonly property bool menuOpened: false

	// Rectangle {
	// 	anchors.fill: parent
	// 	color: "blue"
	// }
	//
	// Rectangle {
	// 	anchors.fill: grid
	// 	color: "green"
	// }

	component ModuleGrid: GridLayout {
		rowSpacing: BarConfig.properties.spacing
		columnSpacing: BarConfig.properties.spacing
		rows: 1
		columns: 1
		flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
			: GridLayout.LeftToRight
	}

	component ModuleGroup: ModuleGrid {
		id: moduleGrid
		required property list<string> model

		Repeater {
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
					roleValue: "test"
					delegate: Rectangle {
						color: "red"
						implicitWidth: BarConfig.properties.size - 2 * BarConfig.properties.padding
						implicitHeight: BarConfig.properties.size - 2 * BarConfig.properties.padding
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
			ModuleGroup {
				id: modulesTopOrLeft
				model: BarConfig.modulesTopOrLeft
			}
		}
		ModuleGroup {
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
			ModuleGroup {
				id: modulesBottomOrRight
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
