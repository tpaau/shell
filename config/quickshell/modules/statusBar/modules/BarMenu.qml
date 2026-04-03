import QtQuick
import QtQuick.Controls
import Quickshell
import qs.widgets
import qs.modules.statusBar
import qs.utils
import qs.theme

// Custom `Menu` type designed to work with the status bar. Mainly positioning stuff here.
StyledMenu {
	color: Theme.palette.background

	topMargin: Utils.marginFromEdge(Edges.Top)
	rightMargin: Utils.marginFromEdge(Edges.Right)
	bottomMargin: Utils.marginFromEdge(Edges.Bottom)
	leftMargin: Utils.marginFromEdge(Edges.Left)

	transformOrigin: switch (BarConfig.properties.edge) {
		case Edges.Top:
			return Popup.Top
		case Edges.Right:
			return Popup.Right
		case Edges.Bottom:
			return Popup.Bottom
		case Edges.Left:
			return Popup.Left
		default:
			console.warn(`Unknown Status Bar edge: ${BarConfig.properties.edge}`)
			return Popup.Top
	}
}
