import QtQuick
import Quickshell
import qs.config

Item {
	Loader {
		active: Config.statusBar.enabled
		asynchronous: true

		sourceComponent: PanelWindow {
			implicitWidth: Config.statusBar.size
			implicitHeight: Config.statusBar.size
			mask: Region {}
			color: "transparent"
			anchors {
				top: Config.statusBar.edge == Edges.Top
				right: Config.statusBar.edge == Edges.Right
				bottom: Config.statusBar.edge == Edges.Bottom
				left: Config.statusBar.edge == Edges.Left
			}
		}
	}
}
