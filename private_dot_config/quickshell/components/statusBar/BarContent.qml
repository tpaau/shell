pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.statusBar.modules

GridLayout {
	id: root

	required property bool isHorizontal
	required property int margin
	required property int spacing
	required property ShellScreen screen
	required property BarPopup popup

	anchors {
		fill: parent
		margins: root.margin
	}
	rowSpacing: root.margin
	columnSpacing: root.margin
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
			isHorizontal: root.isHorizontal
			popup: root.popup
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
			popup: root.popup
		}
	}
	BarModuleGroup {
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.alignment: root.isHorizontal ? Qt.AlignRight : Qt.AlignBottom
		flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

		BottomRightIndicators {
			isHorizontal: root.isHorizontal
			popup: root.popup
		}
	}

	component BarModuleGroup: GridLayout {
		columnSpacing: root.spacing
		rowSpacing: root.spacing
		flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight
	}
}
