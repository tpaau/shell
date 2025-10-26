import QtQuick
import qs.widgets
import qs.config

LargeStyledSlider {
	id: root
	implicitHeight: 40
	minWidth: icon.height

	required property string text

	StyledIcon {
		id: icon
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			leftMargin: (root.height - width) / 2
		}
		text: root.text
		color: Theme.pallete.bg.c1
	}
}
