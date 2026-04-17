import QtQuick
import qs.widgets
import qs.theme
import qs.config
import qs.utils

Item {
    id: root

    property color color: Theme.palette.primary
    property real radius: 0
    property bool enabled: Config.appearance.ripple.enabled

    property real _rippleX: 0
    property real _rippleY: 0
    property real _rippleMaxRadius: 0
    readonly property alias animating: rippleAnim.running

    anchors.fill: parent
    visible: enabled

    function trigger(x, y) {
        if (!enabled || Config.animations.speedMultiplier == 0) return

        _rippleX = x
        _rippleY = y

        const dist = (ox, oy) => ox * ox + oy * oy
        _rippleMaxRadius = Math.sqrt(Math.max(dist(x, y), dist(x, height - y), dist(width - x, y), dist(width - x, height - y)))

        rippleAnim.restart()
    }

    SequentialAnimation {
        id: rippleAnim

        PropertyAction {
            target: rippleFx
            property: "rippleCenterX"
            value: root._rippleX
        }
        PropertyAction {
            target: rippleFx
            property: "rippleCenterY"
            value: root._rippleY
        }
        PropertyAction {
            target: rippleFx
            property: "rippleRadius"
            value: 0
        }
        PropertyAction {
            target: rippleFx
            property: "rippleOpacity"
            value: 0.10
        }

        ParallelAnimation {
			M3NumberAnim {
				target: rippleFx
				property: "rippleRadius"
				from: 0
				to: root._rippleMaxRadius
				data: Anims.current.effects.slow
			}
            SequentialAnimation {
                PauseAnimation {
                    duration: 200
                }
				M3NumberAnim {
					target: rippleFx
					property: "rippleOpacity"
					to: 0
					data: Anims.current.effects.slow
				}
            }
        }
    }

    ShaderEffect {
        id: rippleFx
        visible: rippleAnim.running

        property real rippleCenterX: 0
        property real rippleCenterY: 0
        property real rippleRadius: 0
        property real rippleOpacity: 0

        x: Math.max(0, rippleCenterX - rippleRadius)
        y: Math.max(0, rippleCenterY - rippleRadius)
        width: Math.max(0, Math.min(root.width, rippleCenterX + rippleRadius) - x)
        height: Math.max(0, Math.min(root.height, rippleCenterY + rippleRadius) - y)

        property real widthPx: width
        property real heightPx: height
        property real cornerRadiusPx: root.radius
        property real offsetX: x
        property real offsetY: y
        property real parentWidth: root.width
        property real parentHeight: root.height
        property vector4d rippleCol: Qt.vector4d(root.color.r, root.color.g, root.color.b, root.color.a)

        fragmentShader: Paths.shadersDir + "/ripple.frag.qsb"
    }
}
