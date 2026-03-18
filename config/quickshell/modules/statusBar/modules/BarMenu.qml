import QtQuick
import QtQuick.Controls
import Quickshell
import qs.widgets
import qs.config
import qs.theme

// Custom `Menu` type designed to work with the status bar. Mainly positioning stuff here.
StyledMenu {
	color: Theme.palette.background

	function marginForEdge(edge: int): int {
		if (root.isBarSolid && Config.statusBar.edge === edge) {
			return Config.statusBar.size + Config.wm.windowGaps
		} else if (Config.screenDecorations.edges.enabled) {
			return Config.screenDecorations.edges.size + Config.wm.windowGaps
		}
		return 0
	}

	topMargin: marginForEdge(Edges.Top)
	rightMargin: marginForEdge(Edges.Right)
	bottomMargin: marginForEdge(Edges.Bottom)
	leftMargin: marginForEdge(Edges.Left)

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
			return -width - 2 * Config.statusBar.padding - Config.wm.windowGaps
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
			return -height - 2 * Config.statusBar.padding - Config.wm.windowGaps
		default:
			return 0
	}
}
