pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.config

Item {
	id: root
	readonly property int radius: Config.rounding.window
	readonly property color color: Theme.pallete.bg.c1

	Corner {
		anchors {
			left: true
			top: true
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
			right: true
			top: true
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
			right: true
			bottom: true
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
			left: true
			bottom: true
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

	component Corner: PanelWindow {
		id: window
		implicitWidth: root.radius
		implicitHeight: root.radius
		exclusionMode: Config.statusBar.style == 0 ?
			ExclusionMode.Ignore : ExclusionMode.Auto

		color: "transparent"

		default property alias data: shapePath.pathElements
		property alias shapePath: shapePath

		Shape {
			anchors.fill: parent

			ShapePath {
				id: shapePath
				pathHints: ShapePath.PathFillOnRight
					| ShapePath.PathSolid
					| ShapePath.PathNonIntersecting
				fillColor: root.color
				strokeWidth: -1
			}
		}
	}
}
