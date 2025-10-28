pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.statusBar.modules
import qs.config

LazyLoader {
	active: Config.statusBar.enabled

	PanelWindow {
		id: root
		color: Theme.pallete.bg.c1

		readonly property int margin: Config.statusBar.margin

		readonly property int alignment: Config.alignmentFromStr(
			Config.statusBar.alignment)

		readonly property bool isVertical: {
			if (alignment == Qt.AlignTop
			|| alignment == Qt.AlignBottom) {
				return true
			}
			return false
		}

		implicitWidth: Config.statusBar.size
		implicitHeight: Config.statusBar.size

		mask: Region {
			item: moduleLayout
		}

		readonly property real spacing: Config.spacing.large

		anchors: {
			switch(root.alignment) {
				case Qt.AlignTop:
					return {
						top: true,
						right: true,
						left: true
					}
				case Qt.AlignRight:
					return {
						top: true,
						right: true,
						bottom: true
					}
				case Qt.AlignBottom:
					return {
						right: true,
						bottom: true,
						left: true
					}
				case Qt.AlignLeft:
					return {
						top: true,
						bottom: true,
						left: true
					}
			}
		}

		Rectangle {
			color: "black"
			anchors.fill: moduleLayout
		}

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
			flow: root.isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight

			ModuleGroup {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.alignment: root.isVertical ? Qt.AlignLeft : Qt.AlignTop
				flow: root.isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight

				TopLeftIndicators {
					isVertical: root.isVertical
				}
			}
			ModuleGroup {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.alignment: Qt.AlignCenter
				flow: root.isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight

				NiriWorkspaces {
					isVertical: root.isVertical
					Layout.alignment: Qt.AlignCenter
				}
			}
			ModuleGroup {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.alignment: root.isVertical ? Qt.AlignRight : Qt.AlignBottom
				flow: root.isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight

				BottomRightIndicators {
					isVertical: root.isVertical
				}
			}

			component ModuleGroup: GridLayout {
				columnSpacing: root.spacing
				rowSpacing: root.spacing
				flow: root.isVertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
			}
		}
	}
}
