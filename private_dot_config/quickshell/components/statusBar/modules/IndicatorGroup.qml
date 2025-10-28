import QtQuick
import QtQuick.Layouts
import qs.config

Rectangle {
	id: root

	default property alias content: layout.data
	required property bool isVertical
	readonly property alias layout: layout

	clip: true

	visible: width > 0 && height > 0
	implicitWidth: isVertical ?
		layout.children.length > 0 ?
			layout.width + Config.statusBar.moduleSize - layout.height : 0
		: Config.statusBar.moduleSize
	implicitHeight: isVertical ?
		Config.statusBar.moduleSize
		: layout.children.length > 0 ?
			layout.height + Config.statusBar.moduleSize - layout.width : 0
	color: Theme.pallete.fg.c4

	GridLayout {
		id: layout
		anchors.centerIn: parent
		flow: root.isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom
	}

	Behavior on implicitWidth {
		enabled: root.isVertical
		NumberAnimation {
			duration: Config.animations.durations.shorter
			easing.type: Config.animations.easings.popout
		}
	}
	Behavior on implicitHeight {
		enabled: !root.isVertical
		NumberAnimation {
			duration: Config.animations.durations.shorter
			easing.type: Config.animations.easings.popout
		}
	}
}
