import qs.enums
import qs.widgets
import qs.theme

StyledSlider {
	id: root

	required property string icon

	StyledIcon {
		anchors {
			top: parent.top
			bottom: parent.bottom
		}

		readonly property bool isLeft: root.fill.width > Math.max(width, height)

		x: isLeft ? root.handle.x - 1.5 * width : root.handle.x + width / 2
		text: root.icon
		color: {
			if (isLeft) {
				switch (root.accent) {
					case Accent.Primary:
						return Theme.palette.on_primary
					case Accent.Secondary:
						return Theme.palette.on_secondary
					case Accent.Tertiary:
						return Theme.palette.on_tertiary
				}
			} else {
				return root.fillColor
			}
			return "magenta"
		}
	}
}
