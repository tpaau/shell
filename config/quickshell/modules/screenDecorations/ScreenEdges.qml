import QtQuick
import Quickshell
import qs.modules.statusBar
import qs.theme
import qs.config

Item {
	Edge {
		active: !BarConfig.properties.enabled || BarConfig.properties.edge != Edges.Top
		anchors {
			top: parent.top
			right: parent.right
			left: parent.left
		}
	}
	Edge {
		active: !BarConfig.properties.enabled || BarConfig.properties.edge != Edges.Right
		anchors {
			top: parent.top
			right: parent.right
			bottom: parent.bottom
		}
	}
	Edge {
		active: !BarConfig.properties.enabled || BarConfig.properties.edge != Edges.Bottom
		anchors {
			right: parent.right
			bottom: parent.bottom
			left: parent.left
		}
	}
	Edge {
		active: !BarConfig.properties.enabled || BarConfig.properties.edge != Edges.Left
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
		}
	}

	component Edge: Loader {
		asynchronous: true
		active: false
		width: Config.screenDecorations.edges.size
		height: Config.screenDecorations.edges.size

		sourceComponent: Rectangle {
			anchors.fill: parent
			color: Theme.palette.background
		}
	}
}
