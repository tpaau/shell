pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.config

Item {
	id: root

	anchors.fill: parent

	readonly property int radius: Config.rounding.window

	Corner {
		anchors {
			top: parent.top
			left: parent.left
			topMargin: Config.statusBar.enabled && Config.statusBar.edge == Edges.Top ?
				Config.statusBar.size
				: Config.screenDecorations.edges.enabled ?
				Config.screenDecorations.edges.size : 0
			leftMargin: Config.statusBar.enabled && Config.statusBar.edge == Edges.Left ?
				Config.statusBar.size
			: Config.screenDecorations.edges.enabled ?
			Config.screenDecorations.edges.size : 0
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
			topMargin: Config.statusBar.enabled && Config.statusBar.edge == Edges.Top ?
				Config.statusBar.size
				: Config.screenDecorations.edges.enabled ?
				Config.screenDecorations.edges.size : 0
			rightMargin: Config.statusBar.enabled
				&& Config.statusBar.edge == Edges.Right ?
				Config.statusBar.size
				: Config.screenDecorations.edges.enabled ?
				Config.screenDecorations.edges.size : 0
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
			rightMargin: Config.statusBar.enabled
				&& Config.statusBar.edge == Edges.Right ?
				Config.statusBar.size
				: Config.screenDecorations.edges.enabled ?
				Config.screenDecorations.edges.size : 0
			bottomMargin: Config.statusBar.enabled
				&& Config.statusBar.edge == Edges.Bottom ?
				Config.statusBar.size
				: Config.screenDecorations.edges.enabled ?
				Config.screenDecorations.edges.size : 0
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
			bottomMargin: Config.statusBar.enabled
				&& Config.statusBar.edge == Edges.Bottom ?
				Config.statusBar.size
				: Config.screenDecorations.edges.enabled ?
				Config.screenDecorations.edges.size : 0
			leftMargin: Config.statusBar.enabled&& Config.statusBar.edge == Edges.Left ?
				Config.statusBar.size
				: Config.screenDecorations.edges.enabled ?
				Config.screenDecorations.edges.size : 0
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

	component Corner: Shape {
		implicitWidth: root.radius
		implicitHeight: root.radius

		default property alias data: shapePath.pathElements
		property alias shapePath: shapePath

		ShapePath {
			id: shapePath
			pathHints: ShapePath.PathFillOnRight
				| ShapePath.PathSolid
				| ShapePath.PathNonIntersecting
			fillColor: Theme.palette.background
			strokeWidth: -1
		}
	}
}
