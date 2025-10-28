import QtQuick
import Quickshell
import qs.config

Item {
	Win {
		anchors {
			top: true
			right: true
			left: true
		}
	}
	Win {
		anchors {
			top: true
			right: true
			bottom: true
		}
	}
	Win {
		anchors {
			right: true
			bottom: true
			left: true
		}
	}
	ScreenCorners {}

	component Win: PanelWindow {
		implicitWidth: Config.screenDecorations.edges.size
		implicitHeight: Config.screenDecorations.edges.size
		color: Theme.pallete.bg.c1
	}
}
