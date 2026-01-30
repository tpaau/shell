import QtQuick
import Quickshell
import qs.config

Item {
	id: root

	required property ShellScreen screen

	component ExclusionWindow: PanelWindow {
		screen: root.screen
		mask: Region {}
		color: "transparent"
		implicitWidth: 0
		implicitHeight: 0
	}

	LazyLoader {
		active: Config.statusBar.enabled

		ExclusionWindow {
			implicitWidth: Config.statusBar.size
			implicitHeight: Config.statusBar.size
			anchors {
				top: Config.statusBar.edge === Edges.Top
				right: Config.statusBar.edge === Edges.Right
				bottom: Config.statusBar.edge === Edges.Bottom
				left: Config.statusBar.edge === Edges.Left
			}
		}
	}

	LazyLoader {
		active: !Config.statusBar.enabled || Config.screenDecorations.edges.enabled && Config.statusBar.edge !== Edges.Top

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.top: true
		}
	}

	LazyLoader {
		active: !Config.statusBar.enabled || Config.screenDecorations.edges.enabled && Config.statusBar.edge !== Edges.Right

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.right: true
		}
	}

	LazyLoader {
		active: !Config.statusBar.enabled || Config.screenDecorations.edges.enabled && Config.statusBar.edge !== Edges.Bottom

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.bottom: true
		}
	}

	LazyLoader {
		active: !Config.statusBar.enabled || Config.screenDecorations.edges.enabled && Config.statusBar.edge !== Edges.Left

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.left: true
		}
	}
}
