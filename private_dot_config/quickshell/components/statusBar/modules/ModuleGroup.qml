import QtQuick
import QtQuick.Layouts
import qs.config

Rectangle {
	id: root

	required property bool isHorizontal
	required property ModuleGroup topOrLeft
	required property ModuleGroup bottomOrRight

	readonly property alias layout: layout
	readonly property int radiusSmall: Config.rounding.smaller
	readonly property int radiusLarge: Config.statusBar.moduleSize / 2

	default property alias content: layout.data

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

	color: Theme.palette.accent
	topRightRadius: isHorizontal ?
		bottomOrRight && bottomOrRight.visible ? radiusSmall : radiusLarge
		: topOrLeft && topOrLeft.visible ? radiusSmall : radiusLarge
	topLeftRadius: topOrLeft && topOrLeft.visible ? radiusSmall : radiusLarge
	bottomRightRadius: bottomOrRight && bottomOrRight.visible ? radiusSmall : radiusLarge
	bottomLeftRadius: isHorizontal ?
		topOrLeft && topOrLeft.visible ? radiusSmall : radiusLarge
		: bottomOrRight && bottomOrRight.visible ? radiusSmall : radiusLarge

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
