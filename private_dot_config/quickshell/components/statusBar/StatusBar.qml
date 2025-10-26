pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.components.statusBar.modules
import qs.components.quickSettings

PanelWindow {
	id: root

	anchors {
		top: true
		left: true
		right: true
	}
	implicitHeight: Config.statusBar.size

	readonly property real spacing: Config.spacing.large

	color: Theme.pallete.bg.c1

	required property QuickSettings quickSettings

	MouseArea {
		id: activatorHoverArea
		anchors {
			fill: parent
			leftMargin: (root.width - Config.quickSettings.activatorWidth) / 2
			rightMargin: (root.width - Config.quickSettings.activatorWidth) / 2
		}

		hoverEnabled: true

		MouseArea {
			anchors {
				top: parent.top
				right: parent.right
				left: parent.left
			}

			implicitHeight: Config.quickSettings.activatorHeight
			hoverEnabled: true
			onEntered: root.quickSettings.open()

			Rectangle {
				anchors.fill: parent
				color: Theme.pallete.bg.c4
				opacity: activatorHoverArea.containsMouse
				bottomLeftRadius: height / 2
				bottomRightRadius: height / 2

				Behavior on opacity {
					NumberAnimation {
						duration: Config.animations.durations.shorter
					}
				}
			}
		}
	}

	RowLayout {
		id: rootModules
		anchors.fill: parent
		uniformCellSizes: true

		ModuleGroup {
			id: modulesLeft
			Layout.alignment: Qt.AlignLeft

			Clock {}
			Tray {
				itemSize: 18
			}
		}

		ModuleGroup {
			id: modulesCenter

			Layout.alignment: Qt.AlignCenter

			NiriWorkspaces {}
		}

		ModuleGroup {
			id: modulesRight
			Layout.alignment: Qt.AlignRight

			CaffeineIndicator {}
			BluetoothIndicator {}
			CpuUsage {}
			CpuTemp {}
			MemUsage {}
			// Privacy {}
			Power {
				implicitHeight: root.height * 0.75
			}
		}
	}

	component ModuleGroup: RowLayout {
		id: group

		spacing: root.spacing
		Layout.leftMargin: root.spacing
		Layout.rightMargin: root.spacing

		property int alignment: Layout.alignment
	}
}
