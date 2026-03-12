import QtQuick
import qs.config

Item {
	anchors.fill: parent

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
