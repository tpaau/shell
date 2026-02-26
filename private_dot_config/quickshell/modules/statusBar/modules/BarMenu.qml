import Quickshell
import QtQuick.Controls
import qs.widgets
import qs.services.config

StyledMenu {
	color: Theme.palette.background
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
			return -Config.statusBar.size + Config.statusBar.padding
		case Edges.Left:
			return Config.statusBar.size - Config.statusBar.padding
		default:
			return 0
	}
	y: switch (Config.statusBar.edge) {
		case Edges.Top:
			return Config.statusBar.size - Config.statusBar.padding
		case Edges.Bottom:
			return -Config.statusBar.size + Config.statusBar.padding
		default:
			return 0
	}
}
