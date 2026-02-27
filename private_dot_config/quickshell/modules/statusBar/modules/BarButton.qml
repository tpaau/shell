import qs.widgets
import qs.services.config

StyledButton {
	id: root
	implicitWidth: Config.statusBar.size - 4 * Config.statusBar.padding
	implicitHeight: Config.statusBar.size - 4 * Config.statusBar.padding
	radius: (Config.statusBar.size - 2 * Config.statusBar.padding) / 2
	theme: StyledButton.Theme.OnSurfaceContainer
	property alias icon: icon

	StyledIcon {
		id: icon
		anchors.centerIn: parent
		font.pixelSize: Math.min(root.width, root.height) - root.radius / 2
	}
}
