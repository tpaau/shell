pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.statusBar.modules
import qs.config

Loader {
	id: root
	active: Config.statusBar.enabled
	asynchronous: true

	readonly property int margin: Config.statusBar.margin
	readonly property real spacing: Config.spacing.large
	readonly property int edge: Config.statusBar.edge

	readonly property bool isHorizontal: {
		if (edge == Edges.Top
		|| edge == Edges.Bottom) {
			return true
		}
		return false
	}

	width: isHorizontal ? parent.width : Config.statusBar.size
	height: isHorizontal ? Config.statusBar.size : parent.height
	anchors {
		top: edge == Edges.Top ? parent.top : undefined
		right: edge == Edges.Right ? parent.right : undefined
		bottom: edge == Edges.Bottom ? parent.bottom : undefined
		left: edge == Edges.Left ? parent.left : undefined
	}

	sourceComponent: Rectangle {
		color: Theme.pallete.bg.c1

		GridLayout {
			id: moduleLayout
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
			flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

			ModuleGroup {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.alignment: root.isHorizontal ? Qt.AlignLeft : Qt.AlignTop
				flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

				TopLeftIndicators {
					isHorizontal: root.isHorizontal
				}
			}
			ModuleGroup {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.alignment: Qt.AlignCenter
				flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

				NiriWorkspaces {
					isHorizontal: root.isHorizontal
					Layout.alignment: Qt.AlignCenter
				}
			}
			ModuleGroup {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.alignment: root.isHorizontal ? Qt.AlignRight : Qt.AlignBottom
				flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

				BottomRightIndicators {
					isHorizontal: root.isHorizontal
				}
			}

			component ModuleGroup: GridLayout {
				columnSpacing: root.spacing
				rowSpacing: root.spacing
				flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight
			}
		}
	}
}
