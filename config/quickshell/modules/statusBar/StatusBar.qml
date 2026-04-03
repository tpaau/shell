pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.theme

Item {
	id: root

	anchors.fill: parent

	required property ShellScreen screen

	readonly property Item region: content?.menuOpened ? root : barLoader
	readonly property alias barLoader: barLoader
	readonly property int edge: BarConfig.properties.edge
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

		active: BarConfig.properties.enabled
		asynchronous: true

		// Prevent weird quirky animations and bugs when the status bar changes
		// orientation
		// TODO: Move this to one of the lower loaders to reduce the amount of
		// stuff reloaded
		Connections {
			target: BarConfig.properties

			function onEdgeChanged() {
				if (barLoader.active) {
					barLoader.active = false
					barLoader.active = Qt.binding(() => BarConfig.properties.enabled)
				}
			}
		}

		width: root.isHorizontal ? parent.width : BarConfig.properties.size
		height: root.isHorizontal ? BarConfig.properties.size : parent.height
		// Can't use anchors for some reason, causes unexpected behavior
		x: root.edge === Edges.Right ? parent.width - width : 0
		y: root.edge === Edges.Bottom ? parent.height - height : 0

		component ContentLoader: Loader {
			anchors.fill: parent
			asynchronous: true
			width: parent.width
			height: parent.height

			sourceComponent: BarContent {
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
						0 : BarConfig.properties.secondaryOffsets
					rightMargin: root.edge === Edges.Right ? -1 : root.isHorizontal ?
						BarConfig.properties.secondaryOffsets : 0
					bottomMargin: root.edge === Edges.Bottom ? -1 : root.isHorizontal ?
						0 : BarConfig.properties.secondaryOffsets
					leftMargin: root.edge === Edges.Left ? -1 : root.isHorizontal ?
						BarConfig.properties.secondaryOffsets : 0
				}

				layer.enabled: true
				layer.effect: StyledShadow {}

				readonly property int fullRadius:
					(BarConfig.properties.size - 2 * BarConfig.properties.padding) / 2
					+ 2 * BarConfig.properties.padding
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
						0 : BarConfig.properties.secondaryOffsets
					rightMargin: root.edge === Edges.Right ? -1 : root.isHorizontal ?
						BarConfig.properties.secondaryOffsets : 0
					bottomMargin: root.edge === Edges.Bottom ? -1 : root.isHorizontal ?
						0 : BarConfig.properties.secondaryOffsets
					leftMargin: root.edge === Edges.Left ? -1 : root.isHorizontal ?
						BarConfig.properties.secondaryOffsets : 0
				}

				ContentLoader {}
			}
		}

		sourceComponent: {
			if (BarConfig.properties.wrapperStyle === StatusBar.Style.AttachedRect) {
				return attachedRectWrapper
			}
			else if (BarConfig.properties.wrapperStyle === StatusBar.Style.Rect) {
				return rectWrapper
			}
			else if (BarConfig.properties.wrapperStyle === StatusBar.Style.FloatingRect) {
				return floatingRectWrapper
			}
			else if (BarConfig.properties.wrapperStyle === StatusBar.Style.Shape) {
				return shapeWrapper
			}
			else {
				console.warn(`Unknown bar wrapper style ID: ${BarConfig.properties.wrapperStyle}. The status bar will not be loaded.`)
			}
		}
	}
}
