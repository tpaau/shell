pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell
import qs.widgets.popout
import qs.widgets
import qs.config

Item {
	id: root

	readonly property int radius: Appearance.rounding.window
	readonly property color color: Theme.pallete.bg.c1

	Corner {
		anchors {
			left: true
			top: true
		}

		BasePopoutShape {
			fillColor: root.color
			startX: root.radius

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
	}

	Corner {
		anchors {
			right: true
			top: true
		}

		BasePopoutShape {
			fillColor: root.color

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
	}

	Corner {
		anchors {
			right: true
			bottom: true
		}

		BasePopoutShape {
			fillColor: root.color
			startX: root.radius
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
	}

	Corner {
		anchors {
			left: true
			bottom: true
		}

		BasePopoutShape {
			startX: root.radius
			startY: root.radius

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

	component Corner: PanelWindow {
		id: window
		implicitWidth: root.radius
		implicitHeight: root.radius

		color: "transparent"

		default property alias content: shape.data
		property alias shape: shape

		Shape {
			id: shape
			anchors {
				fill: parent
				topMargin: window.anchors.top ? -1 : 0
				rightMargin: window.anchors.right ? -1 : 0
				bottomMargin: window.anchors.bottom ? -1 : 0
				leftMargin: window.anchors.left ? -1 : 0
			}

			antialiasing: true
			layer.enabled: true
			layer.samples: Appearance.misc.layerSampling
			layer.effect: StyledShadow {}
		}
	}
}
