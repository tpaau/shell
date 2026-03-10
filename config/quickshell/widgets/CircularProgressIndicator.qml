pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import qs.services.config.theme

/**
 * Material 3 circular progress. See https://m3.material.io/components/progress-indicators/specs
 */
Item {
    id: root

    property color primaryColor: Theme.palette.on_secondary_container
    property color secondaryColor: Theme.palette.secondary_container
    property real value: 0.5
    property real gapAngle: 360 / 18
    property int implicitSize: 40
    property int lineWidth: 4
    property int animationDuration: 800
    property int easingType: Easing.OutCubic
    property int fillOverflow: 2
    property bool fill: false
    property bool enableAnimation: true

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    readonly property real degree: value * 360
    readonly property real centerX: root.width / 2
    readonly property real centerY: root.height / 2
    readonly property real arcRadius: root.implicitSize / 2 - root.lineWidth
    readonly property real startAngle: -90

    Loader {
        active: root.fill
        anchors.fill: parent

        sourceComponent: Rectangle {
            radius: Math.min(width, height) / 2
            color: root.secondaryColor
        }
    }

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            id: secondaryPath
            strokeColor: root.secondaryColor
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle - root.gapAngle
                sweepAngle: -(360 - root.degree - 2 * root.gapAngle)
            }
        }
        ShapePath {
            id: primaryPath
            strokeColor: root.primaryColor
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"

            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle
                sweepAngle: root.degree
            }
        }
    }

}
