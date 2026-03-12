pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.statusBar.modules
import qs.config

GridLayout {
	id: root

	required property bool isHorizontal
	required property ShellScreen screen

	readonly property bool menuOpened: topLeftIndicators.menuOpened
		|| bottomRightIndicators.menuOpened

	anchors {
		fill: parent
		margins: Config.statusBar.padding
	}
	rowSpacing: Config.statusBar.spacing
	columnSpacing: Config.statusBar.spacing
	uniformCellWidths: true
	uniformCellHeights: true
	rows: 1
	columns: 1
	flow: root.isHorizontal ? GridLayout.TopToBottom
		: GridLayout.LeftToRight

	BarModuleGroup {
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.alignment: root.isHorizontal ? Qt.AlignLeft : Qt.AlignTop
		flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

		TopLeftIndicators {
			id: topLeftIndicators
			isHorizontal: root.isHorizontal
		}
	}
	BarModuleGroup {
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.alignment: Qt.AlignCenter
		flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

		NiriWorkspaces {
			id: niriWorkspaces
			isHorizontal: root.isHorizontal
			Layout.alignment: Qt.AlignCenter
			screen: root.screen
		}
	}
	BarModuleGroup {
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.alignment: root.isHorizontal ? Qt.AlignRight : Qt.AlignBottom
		flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

		BottomRightIndicators {
			id: bottomRightIndicators
			isHorizontal: root.isHorizontal
		}
	}

	component BarModuleGroup: GridLayout {
		columnSpacing: Config.statusBar.spacing
		rowSpacing: Config.statusBar.spacing
		flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight
	}
}
