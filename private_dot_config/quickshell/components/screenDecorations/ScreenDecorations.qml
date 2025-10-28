pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.config

Item {
	id: root

	readonly property int radius: Config.rounding.window
	readonly property color color: Theme.pallete.bg.c1

	LazyLoader {
		active: Config.screenDecorations.corners.enabled
		ScreenCorners {}
	}
	LazyLoader {
		active: Config.screenDecorations.edges.enabled
		ScreenEdges {}
	}
}
