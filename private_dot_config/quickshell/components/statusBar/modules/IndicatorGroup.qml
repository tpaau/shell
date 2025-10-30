import QtQuick
import QtQuick.Layouts
import qs.config

Rectangle {
	id: root

	default property alias content: layout.data
	required property bool isVertical
	readonly property alias layout: layout

	clip: true

	component Anim: NumberAnimation {
		duration: Config.animations.durations.shorter
		easing.type: Config.animations.easings.popout
	}

	visible: width > 0 && height > 0
	implicitWidth: isVertical ?
		layout.children.length > 0 ?
			layout.width + 2 * Config.statusBar.margin : 0
		: Config.statusBar.moduleSize
	implicitHeight: isVertical ?
		Config.statusBar.moduleSize
		: layout.children.length > 0 ?
			layout.height + 2 * Config.statusBar.margin : 0
	color: Theme.pallete.fg.c4

	GridLayout {
		id: layout
		anchors.centerIn: parent
		flow: root.isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom
	}

	Behavior on radius {
		Anim {}
	}
	Behavior on topRightRadius {
		Anim {}
	}
	Behavior on topLeftRadius {
		Anim {}
	}
	Behavior on bottomRightRadius {
		Anim {}
	}
	Behavior on bottomLeftRadius {
		Anim {}
	}
	Behavior on implicitWidth {
		enabled: root.isVertical
		Anim {}
	}
	Behavior on implicitHeight {
		enabled: !root.isVertical
		Anim {}
	}
}
