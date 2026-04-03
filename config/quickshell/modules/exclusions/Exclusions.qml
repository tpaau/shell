import QtQuick
import Quickshell
import qs.modules.statusBar
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
		active: BarConfig.properties.enabled

		ExclusionWindow {
			implicitWidth: BarConfig.properties.size
			implicitHeight: BarConfig.properties.size
			anchors {
				top: BarConfig.properties.edge === Edges.Top
				right: BarConfig.properties.edge === Edges.Right
				bottom: BarConfig.properties.edge === Edges.Bottom
				left: BarConfig.properties.edge === Edges.Left
			}
		}
	}

	LazyLoader {
		active: !BarConfig.properties.enabled
			|| Config.screenDecorations.edges.enabled
			&& BarConfig.properties.edge !== Edges.Top

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.top: true
		}
	}

	LazyLoader {
		active: !BarConfig.properties.enabled
			|| Config.screenDecorations.edges.enabled
			&& BarConfig.properties.edge !== Edges.Right

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.right: true
		}
	}

	LazyLoader {
		active: !BarConfig.properties.enabled
			|| Config.screenDecorations.edges.enabled
			&& BarConfig.properties.edge !== Edges.Bottom

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.bottom: true
		}
	}

	LazyLoader {
		active: !BarConfig.properties.enabled
			|| Config.screenDecorations.edges.enabled
			&& BarConfig.properties.edge !== Edges.Left

		ExclusionWindow {
			implicitWidth: Config.screenDecorations.edges.size
			implicitHeight: Config.screenDecorations.edges.size
			anchors.left: true
		}
	}
}
