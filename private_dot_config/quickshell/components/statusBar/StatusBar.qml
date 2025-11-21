pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.statusBar.modules
import qs.config

Item {
	id: root

	anchors.fill: parent

	property Item popupRegion: null
	readonly property Item mainRegion: barLoader
	readonly property int margin: Config.statusBar.margin
	readonly property real spacing: Config.spacing.large
	readonly property int edge: Config.statusBar.edge

	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	required property ShellScreen screen

	Loader {
		id: barLoader

		active: Config.statusBar.enabled
		asynchronous: true

		anchors {
			top: root.edge === Edges.Top ? parent.top : undefined
			right: root.edge === Edges.Right ? parent.right : undefined
			bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
			left: root.edge === Edges.Left ? parent.left : undefined
		}
		width: root.isHorizontal ? parent.width : Config.statusBar.size
		height: root.isHorizontal ? Config.statusBar.size : parent.height

		sourceComponent: Rectangle {
			color: Theme.palette.background

			BarPopup {
				id: popup
				Component.onCompleted: root.popupRegion = Qt.binding(function() {
					return active ? this : null
				})
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
				flow: root.isHorizontal ? GridLayout.TopToBottom
					: GridLayout.LeftToRight

				BarModuleGroup {
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.alignment: root.isHorizontal ? Qt.AlignLeft : Qt.AlignTop
					flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

					TopLeftIndicators {
						isHorizontal: root.isHorizontal
						popup: popup
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
						popup: popup
					}
				}
				BarModuleGroup {
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.alignment: root.isHorizontal ? Qt.AlignRight : Qt.AlignBottom
					flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

					BottomRightIndicators {
						isHorizontal: root.isHorizontal
						popup: popup
					}
				}

				component BarModuleGroup: GridLayout {
					columnSpacing: root.spacing
					rowSpacing: root.spacing
					flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight
				}
			}
		}
	}
}
