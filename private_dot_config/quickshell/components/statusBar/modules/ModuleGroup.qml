import QtQuick
import qs.config

Rectangle {
	id: root

	required property bool isHorizontal
	required property ModuleGroup topOrLeft
	required property ModuleGroup bottomOrRight

	readonly property alias layout: layout
	readonly property int spacing: Config.spacing.smaller
	readonly property int radiusSmall: Config.rounding.smaller
	readonly property int radiusLarge: Config.statusBar.moduleSize / 2

	default property alias content: layout.data

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

	component Anim: NumberAnimation {
		duration: Config.animations.durations.shorter
		easing.type: Config.animations.easings.popout
	}

	Grid {
		id: layout
		anchors.centerIn: parent
		rows: root.isHorizontal ? 1 : children.length
		columns: root.isHorizontal ? children.length : 1
		rowSpacing: root.spacing
		columnSpacing: root.spacing
		bottomPadding: root.isHorizontal ? 0 : -root.spacing
		rightPadding: root.isHorizontal ? -root.spacing : 0

        add: Transition {
            Anim {
                properties: "scale"
                from: 0
                to: 1
            }
        }

        move: Transition {
            Anim {
                properties: "scale"
                to: 1
            }
            Anim { properties: "x,y" }
        }
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
