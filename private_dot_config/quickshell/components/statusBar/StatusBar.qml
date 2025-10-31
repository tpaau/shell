pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.statusBar.modules
import qs.config

LazyLoader {
	id: root
	active: Config.statusBar.enabled

	readonly property int margin: Config.statusBar.margin
	readonly property real spacing: Config.spacing.large

	readonly property int alignment: Config.alignmentFromStr(
		Config.statusBar.alignment)

	readonly property bool isHorizontal: {
		if (alignment == Qt.AlignTop
		|| alignment == Qt.AlignBottom) {
			return true
		}
		return false
	}

	Item {
		LazyLoader {
			id: dialog
			active: false

			property bool shouldClose: false
			function open() {
				shouldClose = false
				loading = true
			}

			function close() {
				shouldClose = true
			}

			PanelWindow {
				anchors: barWin.anchors
				implicitWidth: Config.statusBar.size + Config.statusBar.dialogSize
				implicitHeight: Config.statusBar.size + Config.statusBar.dialogSize

				color: "#33FF0000"
				exclusiveZone: 0
			}
		}

		PanelWindow {
			id: barWin
			color: Theme.pallete.bg.c1

			implicitWidth: Config.statusBar.size
			implicitHeight: Config.statusBar.size

			mask: Region {
				item: moduleLayout
			}

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
}
