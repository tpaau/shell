import QtQuick
import qs.widgets
import qs.config

LargeStyledSlider {
	id: root
	implicitHeight: 40

	readonly property bool active: value > from || pressed

	fillColor: active ? Theme.palette.slider : Theme.palette.sliderDisabled
	fillColorPressed: Theme.palette.sliderPressed
	minWidth: icon.height

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
            color: root.active ? Theme.palette.textInverted : Theme.palette.text
		}
	]
}
