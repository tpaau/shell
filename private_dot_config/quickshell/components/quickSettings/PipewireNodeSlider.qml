import QtQuick
import QtQuick.Controls
import Quickshell.Services.Pipewire
import qs.widgets
import qs.config

LargeStyledSlider {
	id: root
	implicitHeight: 40

	required property PwNode node
	required property string text

	snapMode: Slider.SnapAlways
	stepSize: 0.05

	PwObjectTracker {
		objects: [root.node]
	}

	StyledIcon {
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			leftMargin: root.height / 4
		}
		text: root.text
		color: Theme.pallete.bg.c1
	}

	value: node?.audio.volume ?? 0
	onValueChanged: if (node) {
		node.audio.volume = value
	}
}
