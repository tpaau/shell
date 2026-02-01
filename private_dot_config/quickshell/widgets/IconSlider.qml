import qs.widgets

StyledSlider {
	id: root

	required property string icon

	StyledIcon {
		z: 1
		anchors {
			top: parent.top
			bottom: parent.bottom
		}
		readonly property bool isLeft: root.fill.width > Math.max(width, height)
		x: isLeft ? root.handle.x - 1.5 * width : root.handle.x + width / 2
		text: root.icon
		color: isLeft ? root.backgroundColor : root.fillColor
	}
}
