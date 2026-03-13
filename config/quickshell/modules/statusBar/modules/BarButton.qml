import qs.widgets
import qs.config

IconButton {
	id: root
	implicitWidth: Config.statusBar.size - 4 * Config.statusBar.padding
	implicitHeight: Config.statusBar.size - 4 * Config.statusBar.padding
	radius: (Config.statusBar.size - 2 * Config.statusBar.padding) / 2
	theme: StyledButton.Theme.OnSurfaceContainer

	icon {
		width: parent.width
		height: parent.height
		font.pixelSize: Math.min(width, height) - root.radius / 2
		color: root.contentColor
	}
}
