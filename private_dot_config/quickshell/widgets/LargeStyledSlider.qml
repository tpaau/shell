import QtQuick
import QtQuick.Controls
import qs.animations
import qs.config

Slider {
	id: root

	property color backgroundColor: Theme.pallete.bg.c4
	property color fillColorIdle: Theme.pallete.fg.c4
	property color fillColorPressed: Theme.pallete.fg.c7

	property color currentColor:
		pressed ? fillColorPressed : fillColorIdle
	Behavior on currentColor {
		ColorTransition {}
	}

	property int minWidth: 0
	property int backgroundHeight: 8
	property int rounding: pressed ? height / 2 : Config.rounding.small

	readonly property alias fill: fill

	handle: null

	Behavior on rounding {
		NumberAnimation {
			duration: Config.animations.durations.shortish
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
