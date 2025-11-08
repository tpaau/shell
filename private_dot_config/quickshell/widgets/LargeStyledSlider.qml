import QtQuick
import QtQuick.Controls
import qs.config

Slider {
	id: root

	property color backgroundColor: Theme.palette.sliderBackground
	property color fillColor: Theme.palette.slider
	property color fillColorPressed: Theme.palette.sliderPressed

	property color currentColor:
		pressed ? fillColorPressed : fillColor
	Behavior on currentColor {
		ColorAnimation {
			duration: Config.animations.durations.shorter
			easing.type: Config.animations.easings.colorTransition
		}
	}

	property int minWidth: 0
	property int backgroundHeight: 8
	property int rounding: pressed ? height / 2 : Config.rounding.small

	readonly property alias fill: fill

	handle: null

	Behavior on rounding {
		NumberAnimation {
			duration: Config.animations.durations.shorter
			easing.type: Config.animations.easings.fadeOut
		}
	}

	background: Rectangle {
		color: root.backgroundColor
		radius: height / 2
		anchors {
			fill: parent
			topMargin: (parent.height - root.backgroundHeight) / 2
			bottomMargin: (parent.height - root.backgroundHeight) / 2
			leftMargin: -root.minWidth
		}
	}

	Rectangle {
		id: fill
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			leftMargin: -root.minWidth
		}
		width: root.width * root.visualPosition + root.minWidth

		radius: root.rounding
		color: root.currentColor
	}
}
