import QtQuick
import qs.widgets
import qs.services.config
import qs.services.config.theme

Rectangle {
	id: root

	required property bool isHorizontal
	required property ModuleGroup topOrLeft
	required property ModuleGroup bottomOrRight

	readonly property alias layout: layout
	readonly property int spacing: Config.statusBar.spacing
	readonly property int radiusSmall: Config.statusBar.spacing / 2
	readonly property int radiusLarge: Math.max(width, height) / 2

	default property alias content: layout.data
	readonly property alias visibleChildren: layout.visibleChildren

	// Whether other module groups should visually "connect" to this group
	property bool connected: visible

	implicitWidth: isHorizontal ?
		layout.visibleChildren > 0 ?
			layout.width + 2 * Config.statusBar.spacing : 0
		: Config.statusBar.size - 2 * Config.statusBar.padding
	implicitHeight: isHorizontal ?
		Config.statusBar.size - 2 * Config.statusBar.padding
		: layout.visibleChildren > 0 ?
			layout.height + 2 * Config.statusBar.spacing : 0

	color: Theme.palette.surface_container_high
	topRightRadius: connected ?
		isHorizontal ?
			bottomOrRight && bottomOrRight.connected ? radiusSmall : radiusLarge
			: topOrLeft && topOrLeft.connected ? radiusSmall : radiusLarge
		: radiusLarge
	topLeftRadius: connected ?
		topOrLeft && topOrLeft.connected ? radiusSmall : radiusLarge
		: radiusLarge
	bottomRightRadius: connected ?
		bottomOrRight && bottomOrRight.connected ? radiusSmall : radiusLarge
		: radiusLarge
	bottomLeftRadius: connected ?
		isHorizontal ?
			topOrLeft && topOrLeft.connected ? radiusSmall : radiusLarge
			: bottomOrRight && bottomOrRight.connected ? radiusSmall : radiusLarge
		: radiusLarge

	component Anim: M3NumberAnim {
		data: Anims.current.effects.fast
	}

	Grid {
		id: layout
		anchors.centerIn: parent
		rows: root.isHorizontal ? 1 : visibleChildren
		columns: root.isHorizontal ? visibleChildren : 1
		rowSpacing: root.spacing
		columnSpacing: root.spacing
		horizontalItemAlignment: Grid.AlignHCenter
		verticalItemAlignment: Grid.AlignVCenter

		readonly property int visibleChildren: {
			let count = 0
			for (const child of children) {
				if (child && child.visible) count++
			}
			return count
		}

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
	Behavior on implicitWidth { Anim {} }
	Behavior on implicitHeight { Anim {} }
}
