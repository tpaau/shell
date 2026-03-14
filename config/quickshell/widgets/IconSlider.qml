import qs.enums
import qs.widgets
import qs.theme

StyledSlider {
	id: root

	readonly property alias icon: icon

	MaterialIcon {
		id: icon
		anchors.verticalCenter: parent.verticalCenter

		readonly property bool isLeft: root.fill.width > 1.5 * implicitSize

		x: isLeft ? root.handle.x - 1.5 * width : root.handle.x + width / 2
		color: {
			if (isLeft) {
				switch (root.accent) {
					case Accent.Primary:
						return Theme.palette.on_primary
					case Accent.Secondary:
						return Theme.palette.on_secondary
					case Accent.Teritary:
						return Theme.palette.on_teritary
				}
			} else {
				return root.fillColor
			}
			return "magenta"
		}
	}
}
