import qs.widgets
import qs.modules.statusBar

IconButton {
	id: root
	implicitWidth: BarConfig.properties.size - 4 * BarConfig.properties.padding
	implicitHeight: BarConfig.properties.size - 4 * BarConfig.properties.padding
	radius: (BarConfig.properties.size - 2 * BarConfig.properties.padding) / 2
	theme: StyledButton.Theme.SurfaceContainer

	icon {
		width: parent.width
		height: parent.height
		font.pixelSize: Math.min(width, height) - root.radius / 2
		color: root.contentColor
	}
}
