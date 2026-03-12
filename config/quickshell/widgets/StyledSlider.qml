import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import qs.enums
import qs.theme
import qs.config

Slider {
	id: root

	property int gap: Config.spacing.normal
	property int accent: Accent.Primary

	readonly property int rounding: Math.min(Config.rounding.smaller, height / 2)
	readonly property int roundingSmall: rounding / 2
	readonly property ClippingRectangle fill: fill

	property color backgroundColor: Theme.palette.surface_container_high
	property color fillColor: switch (accent) {
		case Accent.Primary:
			return Theme.palette.primary
		case Accent.Secondary:
			return Theme.palette.secondary
		case Accent.Teritary:
			return Theme.palette.teritary
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
			color: root.enabled ? root.fillColor : root.fillColorDisabled

			Behavior on color {
				M3ColorAnim { data: Anims.current.effects.fast }
			}
		}
	}
}
