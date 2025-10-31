import QtQuick
import QtQuick.Layouts
import qs.config

Rectangle {
	id: root

	default property alias content: layout.data
	required property bool isHorizontal
	readonly property alias layout: layout

	clip: true

	component Anim: NumberAnimation {
		duration: Config.animations.durations.shorter
		easing.type: Config.animations.easings.popout
	}

	implicitWidth: isHorizontal ?
		layout.children.length > 0 ?
			layout.width + 2 * Config.statusBar.margin : 0
		: Config.statusBar.moduleSize
	implicitHeight: isHorizontal ?
		Config.statusBar.moduleSize
		: layout.children.length > 0 ?
			layout.height + 2 * Config.statusBar.margin : 0
	color: Theme.pallete.fg.c4

	GridLayout {
		id: layout
		anchors.centerIn: parent
		flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
	}

	Behavior on topRightRadius { Anim {} }
	Behavior on topLeftRadius { Anim {} }
	Behavior on bottomRightRadius { Anim {} }
	Behavior on bottomLeftRadius { Anim {} }
	Behavior on implicitWidth {
		enabled: root.isHorizontal
		Anim {}
	}
	Behavior on implicitHeight {
		enabled: !root.isHorizontal
		Anim {}
	}
}
