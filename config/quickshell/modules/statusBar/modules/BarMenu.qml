import QtQuick
import QtQuick.Controls
import Quickshell
import qs.widgets
import qs.modules.statusBar
import qs.config
import qs.theme

// Custom `Menu` type designed to work with the status bar. Mainly positioning stuff here.
StyledMenu {
	color: Theme.palette.background

	topMargin: Config.marginFromEdge(Edges.Top)
	rightMargin: Config.marginFromEdge(Edges.Right)
	bottomMargin: Config.marginFromEdge(Edges.Bottom)
	leftMargin: Config.marginFromEdge(Edges.Left)

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
}
