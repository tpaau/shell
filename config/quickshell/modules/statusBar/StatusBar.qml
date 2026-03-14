pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.config
import qs.theme

Item {
	id: root

	anchors.fill: parent

	required property ShellScreen screen

	readonly property Item region: content?.menuOpened ? root : barLoader
	readonly property alias barLoader: barLoader
	readonly property real spacing: Config.spacing.large
	readonly property int edge: Config.statusBar.edge
	readonly property bool isHorizontal: {
		if (edge === Edges.Top
		|| edge === Edges.Bottom) {
			return true
		}
		return false
	}

	property BarContent content: null

	enum Style {
		AttachedRect, // Rectangle with three edges attached to screen edges
		Rect, // Rectangle with one edge attached
		FloatingRect, // Floating rectangle
		Shape // `PopoutShape` attached with one edge
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

		width: root.isHorizontal ? parent.width : Config.statusBar.size
		height: root.isHorizontal ? Config.statusBar.size : parent.height
		// Can't use anchors for some reason, causes unexpected behavior
		x: root.edge === Edges.Right ? parent.width - width : 0
		y: root.edge === Edges.Bottom ? parent.height - height : 0

		component ContentLoader: Loader {
			anchors.fill: parent
			asynchronous: true
			width: parent.width
			height: parent.height

			sourceComponent: BarContent {
				isHorizontal: root.isHorizontal
				screen: root.screen
				Component.onCompleted: root.content = this
			}
		}

		Component {
			id: attachedRectWrapper

			Rectangle {
				color: Theme.palette.background

				ContentLoader {}
			}
		}

		Component {
			id: rectWrapper

			Rectangle {
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

				layer.enabled: true
				layer.effect: StyledShadow {}

				readonly property int fullRadius:
					(Config.statusBar.size - 2 * Config.statusBar.padding) / 2
					+ 2 * Config.statusBar.padding
				topRightRadius: root.edge === Edges.Left
					|| root.edge === Edges.Bottom ? fullRadius : 0
				topLeftRadius: root.edge === Edges.Right
					|| root.edge === Edges.Bottom ? fullRadius : 0
				bottomRightRadius: root.edge === Edges.Left
					|| root.edge === Edges.Top ? fullRadius : 0
				bottomLeftRadius: root.edge === Edges.Right
					|| root.edge === Edges.Top ? fullRadius : 0
				color: Theme.palette.background

				ContentLoader {}
			}
		}

		Component {
			id: floatingRectWrapper

			// TODO: Make the floating rect wrapper
			Item {
				Component.onCompleted: console.warn("The floating rect wrapper is not yet implemented!")
			}
		}

		Component {
			id: shapeWrapper

			PopoutShape {
				alignment: alignmentFromEdge(root.edge)

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
			if (Config.statusBar.wrapperStyle === StatusBar.Style.AttachedRect) {
				return attachedRectWrapper
			}
			else if (Config.statusBar.wrapperStyle === StatusBar.Style.Rect) {
				return rectWrapper
			}
			else if (Config.statusBar.wrapperStyle === StatusBar.Style.FloatingRect) {
				return floatingRectWrapper
			}
			else if (Config.statusBar.wrapperStyle === StatusBar.Style.Shape) {
				return shapeWrapper
			}
			else {
				console.warn(`Unknown bar wrapper style ID: ${Config.statusBar.wrapperStyle}. The status bar will not be loaded.`)
			}
		}
	}
}
