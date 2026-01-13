pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import qs.widgets
import qs.config

// Shape for displaying a variety of popouts with a built-in wrapper.
Item {
	id: root

	property int style: Config.popouts.style
	property int alignment: PopoutAlignment.top
	property int radius: Config.rounding.popout
	property color color: Theme.palette.background

	default property alias content: wrapper.data

	Loader {
		anchors.fill: parent
		active: true
		asynchronous: true

		sourceComponent: {
			if (root.style === Config.popoutAttached) {
				if (root.alignment === PopoutAlignment.top) {
					return attachedShapeTop
				}
				else if (root.alignment === PopoutAlignment.topRight) {
					return attachedShapeTopRight
				}
				else if (root.alignment === PopoutAlignment.right) {
					return attachedShapeRight
				}
				else if (root.alignment === PopoutAlignment.bottom) {
					return attachedShapeBottom
				}
				else if (root.alignment === PopoutAlignment.left) {
					return attachedShapeLeft
				}
			}
			else if (root.style === Config.popoutDetached) {
				return detachedShape
			}
			else {
				console.warn(`No shapes for style '${root.style}' and alignment '${root.alignment}'!`)
			}
		}
	}

	Item {
		id: wrapper
		anchors {
			fill: parent
			topMargin:
				root.alignment === PopoutAlignment.right ||
				root.alignment === PopoutAlignment.left ? root.radius : 0
			bottomMargin:
				root.alignment === PopoutAlignment.right ||
				root.alignment === PopoutAlignment.left ? root.radius : 0
			rightMargin:
				root.alignment === PopoutAlignment.top ||
				root.alignment === PopoutAlignment.bottom ? root.radius : 0
			leftMargin:
				root.alignment === PopoutAlignment.top ||
				root.alignment === PopoutAlignment.bottom ? root.radius : 0
		}
	}

	component BaseShape: Shape {
		anchors.fill: parent

		default property alias data: shapePath.pathElements
		property alias shapePath: shapePath

		layer.enabled: true
		layer.samples: Config.quality.layerSamples
		layer.effect: StyledShadow {}

		ShapePath {
			id: shapePath
			pathHints: ShapePath.PathFillOnRight
				| ShapePath.PathSolid
				| ShapePath.PathNonIntersecting
			fillColor: root.color
			strokeWidth: -1
		}
	}

	Component {
		id: detachedShape

		Rectangle {
			anchors.fill: parent
			color: root.color
			radius: root.radius
		}
	}

	Component {
		id: attachedShapeTop

		BaseShape {
			PathArc {
				x: root.radius
				y: Math.min(root.radius, root.height / 2)
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
			}
			PathLine {
				x: root.radius
				y: Math.max(root.height - root.radius, root.height / 2)
			}
			PathArc {
				x: 2 * root.radius
				y: root.height
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
				direction: PathArc.Counterclockwise
			}
			PathLine {
				x: root.width - 2 * root.radius
				y: root.height
			}
			PathArc {
				x: root.width - root.radius
				y: Math.max(root.height - root.radius, root.height / 2)
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
				direction: PathArc.Counterclockwise
			}
			PathLine {
				x: root.width - root.radius
				y: Math.min(root.radius, root.height / 2)
			}
			PathArc {
				x: root.width
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
			}
		}
	}

	Component {
		id: attachedShapeTopRight

		BaseShape {
			PathArc {
				x: root.radius
				y: Math.min(root.radius, root.height / 3)
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 3)
			}
			PathLine {
				x: root.radius
				y: Math.max(root.height - 2 * root.radius, root.height / 3)
			}
			PathArc {
				x: 2 * root.radius
				y: Math.max(root.height - root.radius, 2 * root.height / 3)
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 3)
				direction: PathArc.Counterclockwise
			}
			PathLine {
				x: root.width - root.radius
				y: Math.max(root.height - root.radius, 2 * root.height / 3)
			}
			PathArc {
				x: root.width
				y: root.height
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 3)
			}
			PathLine {
				x: root.width
			}
		}
	}

	Component {
		id: attachedShapeRight

		BaseShape {
			shapePath.startX: width
			shapePath.startY: height

			PathArc {
				x: Math.max(root.width - root.radius, root.width / 2)
				y: root.height - root.radius
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
				direction: PathArc.Counterclockwise
			}
			PathLine {
				x: Math.min(root.radius, root.width / 2)
				y: root.height - root.radius
			}
			PathArc {
				y: root.height - 2 * root.radius
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
			}
			PathLine {
				y: 2 * root.radius
			}
			PathArc {
				x: Math.min(root.radius, root.width / 2)
				y: root.radius
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
			}
			PathLine {
				x: Math.max(root.width - root.radius, root.width / 2)
				y: root.radius
			}
			PathArc {
				x: root.width
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
				direction: PathArc.Counterclockwise
			}
		}
	}

	Component {
		id: attachedShapeBottom

		BaseShape {
			shapePath.startY: root.height

			PathArc {
				x: root.radius
				y: Math.max(root.height - root.radius, root.height / 2)
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
				direction: PathArc.Counterclockwise
			}
			PathLine {
				x: root.radius
				y: Math.min(root.radius, root.height / 2)
			}
			PathArc {
				x: 2 * root.radius
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
			}
			PathLine {
				x: root.width - 2 * root.radius
			}
			PathArc {
				x: root.width - root.radius
				y: Math.min(root.radius, root.height / 2)
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
			}
			PathLine {
				x: root.width - root.radius
				y: Math.max(root.height - root.radius, root.height / 2)
			}
			PathArc {
				x: root.width
				y: root.height
				radiusX: root.radius
				radiusY: Math.min(root.radius, root.height / 2)
				direction: PathArc.Counterclockwise
			}
			PathLine {
				y: root.height
			}
		}
	}

	Component {
		id: attachedShapeLeft

		BaseShape {
			PathArc {
				x: Math.min(root.radius, root.width / 2)
				y: root.radius
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
				direction: PathArc.Counterclockwise
			}
			PathLine {
				x: Math.max(root.width - root.radius, root.width / 2)
				y: root.radius
			}
			PathArc {
				x: root.width
				y: 2 * root.radius
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
			}
			PathLine {
				x: root.width
				y: root.height - 2 * root.radius
			}
			PathArc {
				x: Math.max(root.width - root.radius, root.width / 2)
				y: root.height - root.radius
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
			}
			PathLine {
				x: Math.min(root.radius, root.width / 2)
				y: root.height - root.radius
			}
			PathArc {
				x: 0
				y: root.height
				radiusX: Math.min(root.radius, root.width / 2)
				radiusY: root.radius
				direction: PathArc.Counterclockwise
			}
		}
	}
}
