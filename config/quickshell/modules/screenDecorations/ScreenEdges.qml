import QtQuick
import Quickshell
// import qs.widgets
import qs.services.config

Item {
	Edge {
		active: !Config.statusBar.enabled || Config.statusBar.edge != Edges.Top
		anchors {
			top: parent.top
			right: parent.right
			left: parent.left
		}
	}
	Edge {
		active: !Config.statusBar.enabled || Config.statusBar.edge != Edges.Right
		anchors {
			top: parent.top
			right: parent.right
			bottom: parent.bottom
		}
	}
	Edge {
		active: !Config.statusBar.enabled || Config.statusBar.edge != Edges.Bottom
		anchors {
			right: parent.right
			bottom: parent.bottom
			left: parent.left
		}
	}
	Edge {
		active: !Config.statusBar.enabled || Config.statusBar.edge != Edges.Left
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
		}
	}

	component Edge: Loader {
		asynchronous: true
		width: Config.screenDecorations.edges.size
		height: Config.screenDecorations.edges.size

		// layer.enabled: Config.screenDecorations.shadowsEnabled
		// layer.samples: Config.quality.layerSamples
		// layer.effect: StyledShadow {}

		Rectangle {
			anchors.fill: parent
			color: Theme.palette.background
		}
	}
}
