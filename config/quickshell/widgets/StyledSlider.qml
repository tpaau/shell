import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.enums
import qs.theme
import qs.config

Slider {
	id: root

	property int fillHeight: 12
	property int handleSize: 12
	property int gap: Config.spacing.normal
	property int accent: Accent.Primary

	implicitWidth: 100
	implicitHeight: fillHeight + handleSize

	readonly property int rounding: Math.min(Config.rounding.smaller, (height - handleSize) / 2)
	readonly property int roundingSmall: rounding / 2
	readonly property ClippingRectangle fill: fill

	property color backgroundColor: Theme.palette.surface_container_high
	property color fillColor: switch (accent) {
		case Accent.Primary:
			return Theme.palette.primary
		case Accent.Secondary:
			return Theme.palette.secondary
		case Accent.Tertiary:
			return Theme.palette.tertiary
		default:
			return "magenta"
	}
	property color fillColorDisabled: Qt.alpha(fillColor, 0.7)

	focusPolicy: Qt.NoFocus

	background: ClippingRectangle {
		id: background

		anchors {
			right: parent.right
			top: parent.top
			bottom: parent.bottom
			topMargin: root.handleSize / 2
			bottomMargin: root.handleSize / 2
		}

		color: "transparent"
		radius: root.roundingSmall

		width: Math.max(
			parent.width - root.visualPosition * root.width - root.gap * 2/3 + handle.width / 2, 0)

		Rectangle {
			anchors {
				top: parent.top
				right: parent.right
				bottom: parent.bottom
			}
			topLeftRadius: root.roundingSmall
			bottomLeftRadius: root.roundingSmall
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
			topMargin: root.handleSize / 2
			bottomMargin: root.handleSize / 2
		}

		color: "transparent"
		radius: root.roundingSmall

		width: Math.max(root.visualPosition * root.width - root.gap / 3 - handle.width / 2, 0)

		Rectangle {
			anchors {
				top: parent.top
				bottom: parent.bottom
				left: parent.left
			}
			topRightRadius: root.roundingSmall
			bottomRightRadius: root.roundingSmall
			topLeftRadius: root.rounding
			bottomLeftRadius: root.rounding
			implicitWidth: Math.max(parent.width, topLeftRadius + topRightRadius)

			color: root.enabled ? root.fillColor : root.fillColorDisabled
			radius: root.rounding

			Behavior on color {
				M3ColorAnim { data: Anims.current.effects.fast }
			}
		}
	}

	handle: Item {
		id: handle
        x: root.visualPosition * root.width - width / 2
        y: root.topPadding + root.availableHeight / 2 - height / 2
		width: root.gap / 3
		height: root.height

		Rectangle {
			anchors {
				top: parent.top
				bottom: parent.bottom
				horizontalCenter: parent.horizontalCenter
			}
			implicitWidth: root.pressed ? parent.width * 0.66 : parent.width

			radius: Math.min(width, height)
			color: root.enabled ? root.fillColor : root.fillColorDisabled

			Behavior on color {
				M3ColorAnim { data: Anims.current.effects.fast }
			}
		}
	}
}
