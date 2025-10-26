import QtQuick
import QtQuick.Controls
import qs.animations
import qs.config

Slider {
	id: root

	property color backgroundColor: Theme.pallete.bg.c5
	property color fillColorIdle: Theme.pallete.fg.c4
	property color fillColorPressed: Theme.pallete.fg.c7

	property int backgroundHeight: 8
	property int rounding: Config.rounding.small

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
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
		}
		width: root.visualPosition * root.width
		color: root.pressed ? root.fillColorPressed : root.fillColorIdle
		radius: root.rounding

		Behavior on color {
			ColorTransition {}
		}
	}

	handle: null
}
