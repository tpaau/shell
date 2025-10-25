import QtQuick
import QtQuick.Shapes
import qs.config

Rectangle {
	id: root

	required property real progress

	property color backgroundColor: Theme.pallete.bg.c1
	property color indicatorColor: Theme.pallete.fg.c4
	property color indicatorBackgroundColor: Theme.pallete.bg.c4

	property int strokeWidth: 8

	color: backgroundColor
	radius: Math.min(width, height) / 2

	implicitWidth: 50
	implicitHeight: 50

	layer.enabled: true
	antialiasing: true
	layer.samples: Config.quality.layerSamples
	clip: true

	Shape {
		ShapePath {
			strokeWidth: root.strokeWidth
			strokeColor: root.indicatorBackgroundColor
			capStyle: ShapePath.RoundCap
			fillColor: "transparent"

			PathAngleArc {
				centerX: root.width / 2
				centerY: root.height / 2
				radiusX: root.width / 2 - root.strokeWidth / 2
				radiusY: root.height / 2 - root.strokeWidth / 2
				startAngle: 0
				sweepAngle: 360
			}
		}
	}

	Shape {
		ShapePath {
			strokeWidth: root.strokeWidth
			strokeColor: root.indicatorColor
			capStyle: ShapePath.RoundCap
			fillColor: "transparent"

			PathAngleArc {
				centerX: root.width / 2
				centerY: root.height / 2
				radiusX: root.width / 2 - root.strokeWidth / 2
				radiusY: root.height / 2 - root.strokeWidth / 2
				startAngle: -90
				sweepAngle: root.progress * 360
			}
		}
	}
}
