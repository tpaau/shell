import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.services.config

Slider {
	id: root

	property color backgroundColor: Theme.palette.surface_container_high
	property color fillColorDisabled: Theme.palette.on_primary_fixed_variant
	property color fillColor: Theme.palette.primary
	property color fillColorPressed: Theme.palette.primary_fixed

	property int gap: Config.spacing.normal
	property int rounding: Math.min(Config.rounding.smaller, height / 2)

	readonly property ClippingRectangle fill: fill

	focusPolicy: Qt.NoFocus

	background: ClippingRectangle {
		id: background

		anchors {
			right: parent.right
			top: parent.top
			bottom: parent.bottom
		}

		color: "transparent"
		radius: root.rounding / 2

		width: Math.max(
			parent.width - root.visualPosition * root.width - root.gap * 2/3 + handle.width / 2, 0)

		Rectangle {
			anchors {
				top: parent.top
				right: parent.right
				bottom: parent.bottom
			}
			topLeftRadius: root.rounding / 2
			bottomLeftRadius: root.rounding / 2
			topRightRadius: root.rounding
			bottomRightRadius: root.rounding
			implicitWidth: Math.max(parent.width, topLeftRadius + topRightRadius)

			color: root.backgroundColor
		}
	}

	ClippingRectangle {
		id: fill

		anchors {
			left: parent.left
			top: parent.top
			bottom: parent.bottom
		}

		color: "transparent"
		radius: height / 4

		width: Math.max(root.visualPosition * root.width - root.gap / 3 - handle.width / 2, 0)

		Rectangle {
			anchors {
				top: parent.top
				bottom: parent.bottom
				left: parent.left
			}
			topRightRadius: root.rounding / 2
			bottomRightRadius: root.rounding / 2
			topLeftRadius: root.rounding
			bottomLeftRadius: root.rounding
			implicitWidth: Math.max(parent.width, topLeftRadius + topRightRadius)

			color: root.enabled ?
				root.pressed ? root.fillColorPressed : root.fillColor
				: root.fillColorDisabled
			radius: root.rounding

			Behavior on color {
				M3ColorAnim { data: Anims.current.effects.fast }
			}
		}
	}

	handle: Item {
		id: handle
		visible: true
        x: root.visualPosition * root.width - width / 2
        y: root.topPadding + root.availableHeight / 2 - height / 2
		width: root.gap / 3
		height: root.height + 2 * root.rounding

		Rectangle {
			anchors {
				top: parent.top
				bottom: parent.bottom
				horizontalCenter: parent.horizontalCenter
			}
			implicitWidth: root.pressed ? parent.width * 0.66 : parent.width

			radius: Math.min(width, height)
			color: root.enabled ?
				root.pressed ? root.fillColorPressed : root.fillColor
				: root.fillColorDisabled

			Behavior on color {
				M3ColorAnim { data: Anims.current.effects.fast }
			}
		}
	}
}
