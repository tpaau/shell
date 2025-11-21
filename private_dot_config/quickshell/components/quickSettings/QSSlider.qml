import QtQuick
import qs.widgets
import qs.config

StyledSlider {
	id: root
	implicitHeight: 40

	fillColorPressed: Theme.palette.sliderPressed
	backgroundColor: Theme.palette.surface

	required property string text

	StyledIcon {
		id: icon
		z: 1
		anchors {
			top: parent.top
			bottom: parent.bottom
		}
		readonly property bool isLeft: root.fill.width > Math.max(width, height)
		x: isLeft ? root.handle.x - 1.5 * width : root.handle.x + width / 2
		text: root.text
		color: isLeft ? Theme.palette.textInverted : Theme.palette.text
	}
}
