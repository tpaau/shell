pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.components.statusBar.modules
import qs.config

Item {
	id: root

	anchors.fill: parent

	readonly property Item popupRegion: popup.region
	readonly property Item mainRegion: barLoader
	readonly property alias barLoader: barLoader
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

	BarPopup {
		id: popup
	}

	Loader {
		id: barLoader

		active: Config.statusBar.enabled
		asynchronous: true

		// Prevent weird quirky animations and bugs when the status bar changes
		// orientation
		// TODO: Move this to one of the lower loaders to reduce the amount of
		// stuff reloaded
		Connections {
			target: Config.statusBar

			function onEdgeChanged() {
				if (barLoader.active) {
					barLoader.active = false
					barLoader.active = Qt.binding(() => Config.statusBar.enabled)
				}
			}
		}

		anchors {
			top: root.edge === Edges.Top ? parent.top : undefined
			right: root.edge === Edges.Right ? parent.right : undefined
			bottom: root.edge === Edges.Bottom ? parent.bottom : undefined
			left: root.edge === Edges.Left ? parent.left : undefined
		}
		width: root.isHorizontal ? parent.width : Config.statusBar.size
		height: root.isHorizontal ? Config.statusBar.size : parent.height

		Component {
			id: barContent

			BarContent {
				isHorizontal: root.isHorizontal
				margin: root.margin
				spacing: root.spacing
				screen: root.screen
				popup: popup
			}
		}

		component ContentLoader: Loader {
			anchors.fill: parent
			asynchronous: true
			active: true
			sourceComponent: barContent
		}

		Component {
			id: attachedWrapper

			Rectangle {
				color: Theme.palette.background

				ContentLoader {}
			}
		}

		Component {
			id: semiAttachedWrapper

			PopoutShape {
				alignment: PopoutAlignment.fromEdge(root.edge)

				anchors {
					fill: parent
					topMargin: root.edge === Edges.Top ? -1 : root.isHorizontal ?
						0 : Config.statusBar.secondaryOffsets
					rightMargin: root.edge === Edges.Right ? -1 : root.isHorizontal ?
						Config.statusBar.secondaryOffsets : 0
					bottomMargin: root.edge === Edges.Bottom ? -1 : root.isHorizontal ?
						0 : Config.statusBar.secondaryOffsets
					leftMargin: root.edge === Edges.Left ? -1 : root.isHorizontal ?
						Config.statusBar.secondaryOffsets : 0
				}

				ContentLoader {}
			}
		}

		sourceComponent: {
			if (Config.statusBar.wrapperStyle === BarWrapperStyle.attached) {
				return attachedWrapper
			}
			else if (Config.statusBar.wrapperStyle === BarWrapperStyle.semiAttached) {
				return semiAttachedWrapper
			}
			else {
				console.warn(`Unknown bar wrapper style ID: ${Config.statusBar.wrapperStyle}. The status bar will not be loaded.`)
			}
		}
	}
}
