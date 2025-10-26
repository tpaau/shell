import QtQuick
import qs.widgets
import qs.config

LargeStyledSlider {
	id: root
	implicitHeight: 40

	required property string text

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
}
