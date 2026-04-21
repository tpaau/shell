pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.config
import qs.services.niri

Item {
	id: root

	anchors.fill: parent

	required property ShellScreen screen

	opacity: Niri.outputFromShellScreen(screen).hasFullscreenWindowFocused ? 0 : 1
	Behavior on opacity { M3NumberAnim { data: Anims.current.effects.slow } }

	Loader {
		anchors.fill: parent
		active: Config.screenDecorations.corners.enabled
		asynchronous: true
		sourceComponent: ScreenCorners {}
	}
	Loader {
		anchors.fill: parent
		active: Config.screenDecorations.edges.enabled
		asynchronous: true
		sourceComponent: ScreenEdges {}
	}
}
