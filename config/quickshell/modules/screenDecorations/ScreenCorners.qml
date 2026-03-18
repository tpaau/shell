pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.modules.statusBar
import qs.config
import qs.theme

Item {
	id: root

	anchors.fill: parent

	readonly property int radius: Config.rounding.window + Config.wm.windowGaps
	readonly property bool isBarSolid: Config.statusBar.enabled
		&& Config.statusBar.wrapperStyle === StatusBar.Style.AttachedRect

	function marginForEdge(edge: int): int {
		if (root.isBarSolid && Config.statusBar.edge === edge) {
			return Config.statusBar.size
		} else if (Config.screenDecorations.edges.enabled) {
			return Config.screenDecorations.edges.size
		}
		return 0
	}

	readonly property int topMargin: marginForEdge(Edges.Top)
	readonly property int rightMargin: marginForEdge(Edges.Right)
	readonly property int bottomMargin: marginForEdge(Edges.Bottom)
	readonly property int leftMargin: marginForEdge(Edges.Left)

	component Corner: Shape {
		implicitWidth: root.radius
		implicitHeight: root.radius
		preferredRendererType: Shape.CurveRenderer

		anchors {
			topMargin: root.topMargin
			rightMargin: root.rightMargin
			bottomMargin: root.bottomMargin
			leftMargin: root.leftMargin
		}

		default property alias data: shapePath.pathElements
		property alias shapePath: shapePath

		ShapePath {
			id: shapePath
			pathHints: ShapePath.PathSolid
				| ShapePath.PathNonIntersecting
			fillColor: Theme.palette.background
			strokeWidth: -1
		}
	}

	Corner {
		anchors {
			top: parent.top
			left: parent.left
		}

		shapePath.startX: root.radius

		PathLine {}
		PathLine {
			y: root.radius
		}
		PathArc {
			x: root.radius
			radiusX: root.radius
			radiusY: root.radius
		}
	}

	Corner {
		anchors {
			top: parent.top
			right: parent.right
		}

		PathLine {
			x: root.radius
		}
		PathLine {
			x: root.radius
			y: root.radius
		}
		PathArc {
			radiusX: root.radius
			radiusY: root.radius
			direction: PathArc.Counterclockwise
		}
	}

	Corner {
		anchors {
			right: parent.right
			bottom: parent.bottom
		}

		shapePath.startX: root.radius
		PathLine {
			x: root.radius
			y: root.radius
		}
		PathLine {
			y: root.radius
		}
		PathArc {
			x: root.radius
			radiusX: root.radius
			radiusY: root.radius
			direction: PathArc.Counterclockwise
		}
	}

	Corner {
		anchors {
			bottom: parent.bottom
			left: parent.left
		}

		shapePath.startX: root.radius
		shapePath.startY: root.radius

		PathLine {
			y: root.radius
		}
		PathLine {}
		PathArc {
			x: root.radius
			y: root.radius
			radiusX: root.radius
			radiusY: root.radius
			direction: PathArc.Counterclockwise
		}
	}
}
