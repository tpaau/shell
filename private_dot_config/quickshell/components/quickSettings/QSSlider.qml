import QtQuick
import qs.widgets
import qs.config

LargeStyledSlider {
	id: root
	implicitHeight: 40

	fillColorIdle: active ? Theme.pallete.fg.c4 : Theme.pallete.bg.c4
	fillColorPressed: active ? Theme.pallete.fg.c7 : Theme.pallete.bg.c6
	minWidth: icon.height

	required property bool active
	required property string text

	fill.children: [
		StyledIcon {
			id: icon
			z: 1
			anchors {
				top: parent.top
				bottom: parent.bottom
				left: parent.left
				leftMargin: (root.height - width) / 2
			}
			text: root.text
			color: root.active ? Theme.pallete.bg.c1 : Theme.pallete.fg.c4
		}
	]
}
