import QtQuick
import QtQuick.Controls
import Quickshell
import qs.widgets
import qs.services.config
import qs.services.config.theme

StyledMenu {
	color: Theme.palette.background
	margins: Config.wm.windowGaps

	transformOrigin: switch (Config.statusBar.edge) {
		case Edges.Top:
			return Popup.Top
		case Edges.Right:
			return Popup.Right
		case Edges.Bottom:
			return Popup.Bottom
		case Edges.Left:
			return Popup.Left
		default:
			console.warn(`Unknown Status Bar edge: ${Config.statusBar.edge}`)
			return Popup.Top
	}
	x: switch (Config.statusBar.edge) {
		case Edges.Right:
			return -Config.statusBar.size
				+ 2 * Config.statusBar.padding - Config.wm.windowGaps
		case Edges.Left:
			return Config.statusBar.size
				- 2 * Config.statusBar.padding + Config.wm.windowGaps
		default:
			return 0
	}
	y: switch (Config.statusBar.edge) {
		case Edges.Top:
			return Config.statusBar.size
				- 2 * Config.statusBar.padding + Config.wm.windowGaps
		case Edges.Bottom:
			return -Config.statusBar.size
				+ 2 * Config.statusBar.padding - Config.wm.windowGaps
		default:
			return 0
	}
}
