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

	Corner {
		anchors {
			top: parent.top
			left: parent.left
			topMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Top) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
			leftMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Left) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
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
			topMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Top) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
			rightMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Right) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
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
			rightMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Right) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
			bottomMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Bottom) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
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
			bottomMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Bottom) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
			leftMargin: {
				if (root.isBarSolid && Config.statusBar.edge === Edges.Left) {
					if (Config.screenDecorations.edges.enabled) {
						return Config.screenDecorations.edges.size - 1
					}
					return Config.statusBar.size - 1
				}
				return -1
			}
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
