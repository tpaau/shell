import QtQuick
import qs.enums
import qs.theme
import qs.utils

Item {
	id: root

	required property real progress

	property int accent: Accent.Primary

	readonly property int gap: height
	readonly property color mainColor: Accent.toColor(accent)
	readonly property color bgColor: Theme.palette.surface_container_highest
	readonly property real progressNormalized: isNaN(progress) ? 0.0 : Utils.clamp(progress, 0.0, 1.0)

	implicitHeight: 4
	implicitWidth: 200
	clip: true

	Rectangle {
		anchors {
			left: parent.left
			verticalCenter: parent.verticalCenter
		}
		radius: Math.min(width, height) / 2
		implicitWidth: root.width * root.progressNormalized - root.gap / 2
		implicitHeight: Math.min(width, parent.height)
		color: root.mainColor
	}
	Rectangle {
		anchors {
			right: parent.right
			verticalCenter: parent.verticalCenter
		}
		radius: Math.min(width, height) / 2
		implicitWidth: root.width * (1.0 - root.progressNormalized) - root.gap / 2
		implicitHeight: Math.min(width, parent.height)
		color: root.bgColor
	}
}
