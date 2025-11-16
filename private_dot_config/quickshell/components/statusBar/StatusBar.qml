pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.components.statusBar.modules
import qs.widgets
import qs.config
import qs.utils

Item {
	id: root

	anchors.fill: parent

	readonly property int margin: Config.statusBar.margin
	readonly property real spacing: Config.spacing.large
	readonly property int edge: Config.statusBar.edge

	readonly property Item region1: popoutLoader
	readonly property Item region2: barLoader

	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	Loader {
		id: popoutLoader

		active: false
		asynchronous: true

		property bool isClosing: false
		function open(component: Component, anchor: Item): int {
			if (active) return 1
			const status = Utils.checkComponent(component)
			if (status !== 0) return status
			if (!anchor) {
				console.warn("The value 'anchor' musn't be null or undefined!")
				return 3
			}

			isClosing = false
			presentedComponent = component
			anchorItem = anchor
			active = true
		}

		property Component presentedComponent: null
		property Item anchorItem: null

		sourceComponent: PopoutShape {
			anchors {
				top: root.edge === Edges.Top ? parent.top : undefined
				right: root.edge === Edges.Right ? parent.right : undefined
				bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
				left: root.edge === Edges.Left ? parent.left : undefined
				topMargin: root.edge === Edges.Top ? Config.statusBar.size - 1 : 0
				rightMargin: root.edge === Edges.Right ? Config.statusBar.size - 1 : 0
				bottomMargin: root.edge === Edges.Bottom ? Config.statusBar.size - 1 : 0
				leftMargin: root.edge === Edges.Left ? Config.statusBar.size - 1 : 0
			}
			alignment: {
				switch(root.edge) {
					case Edges.Top:
						return PopoutAlignment.top
					case Edges.Right:
						return PopoutAlignment.right
					case Edges.Bottom:
						return PopoutAlignment.bottom
					case Edges.Left:
						return PopoutAlignment.left
				}
			}

			implicitWidth: root.isHorizontal ? contentLoader.width + 4 * radius : 0
			implicitHeight: root.isHorizontal ? 0 : contentLoader.height + 4 * radius

			Component.onCompleted: {
				if (root.isHorizontal) {
					implicitHeight = Qt.binding(function() {
						return popoutLoader.isClosing ?
							0 : contentLoader.width + 2 * radius
					})
				}
				else {
					implicitWidth = Qt.binding(function() {
						return popoutLoader.isClosing ?
							0 : contentLoader.width + 2 * radius
					})
				}
			}

			Behavior on implicitWidth {
				enabled: !root.isHorizontal
				NumberAnimation {
					duration: Config.animations.durations.popout
					easing.type: Config.animations.easings.popout
				}
			}

			Behavior on implicitHeight {
				enabled: root.isHorizontal
				NumberAnimation {
					duration: Config.animations.durations.popout
					easing.type: Config.animations.easings.popout
				}
			}

			Loader {
				id: contentLoader
				anchors.centerIn: parent
				asynchronous: true
				sourceComponent: popoutLoader.presentedComponent
			}
		}
	}

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
					}
				}
				BarModuleGroup {
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.alignment: Qt.AlignCenter
					flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

					NiriWorkspaces {
						isHorizontal: root.isHorizontal
						Layout.alignment: Qt.AlignCenter
					}
				}
				BarModuleGroup {
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.alignment: root.isHorizontal ? Qt.AlignRight : Qt.AlignBottom
					flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

					BottomRightIndicators {
						isHorizontal: root.isHorizontal
						popoutLoader: popoutLoader
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
