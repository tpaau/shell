pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.statusBar.modules
import qs.components.quickSettings
import qs.config

PanelWindow {
	id: root

	required property QuickSettings quickSettings

	readonly property real spacing: Appearance.spacing.large

	anchors {
		top: true
		left: true
		right: true
	}
	implicitHeight: Appearance.misc.statusBarHeight

	// color: "transparent"
	color: Theme.pallete.bg.c1
	// Rectangle {
	// 	anchors.fill: parent
	// 	color: Theme.pallete.bg.c1
	// 	layer.enabled: true
	// 	layer.samples: Appearance.misc.layerSampling
	// 	layer.effect: StyledShadow {}
	// }


	MouseArea {
		anchors {
			top: parent.top
			left: parent.left
			right: parent.right
			leftMargin: (root.width - root.quickSettings.implicitWidth) / 2
			rightMargin: (root.width - root.quickSettings.implicitWidth) / 2
		}
		implicitHeight: 1

		hoverEnabled: true
		onEntered: root.quickSettings.open()
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
