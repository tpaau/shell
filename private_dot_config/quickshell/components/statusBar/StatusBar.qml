pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.components.statusBar.modules
import qs.services

PanelWindow {
	id: root

	anchors {
		top: true
		left: true
		right: true
	}
	implicitHeight: Appearance.misc.statusBarHeight

	readonly property real spacing: Appearance.spacing.large

	color: Theme.pallete.bg.c1

	MouseArea {
		id: activatorHoverArea
		anchors {
			fill: parent
			leftMargin: (root.width - Config.misc.quickSettingsActivatiorWidth) / 2
			rightMargin: (root.width - Config.misc.quickSettingsActivatiorWidth) / 2
		}

		hoverEnabled: true

		MouseArea {
			anchors {
				top: parent.top
				right: parent.right
				left: parent.left
			}

			implicitHeight: Config.misc.quickSettingsActivatiorHeight
			hoverEnabled: true
			onEntered: ShellIpc.quickSettings.open()

			Rectangle {
				anchors.fill: parent
				color: Theme.pallete.bg.c4
				opacity: activatorHoverArea.containsMouse
				bottomLeftRadius: height / 2
				bottomRightRadius: height / 2

				Behavior on opacity {
					NumberAnimation {
						duration: Appearance.anims.durations.shorter
					}
				}
			}
		}
	}

	RowLayout {
		id: barModules
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
