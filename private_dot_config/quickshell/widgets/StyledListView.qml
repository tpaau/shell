pragma ComponentBehavior: Bound

import QtQuick
import qs.config

ListView {
	id: root

	property int highlightRadius: Config.rounding.normal

	spacing: Config.spacing.small / 2
	highlightFollowsCurrentItem: false
	clip: true
	preferredHighlightBegin: 0
	preferredHighlightEnd: height

	highlight: Rectangle {
		color: Theme.palette.surfaceBright
		implicitWidth: root.currentItem?.width ?? 0
		implicitHeight: root.currentItem?.height ?? 0
		y: root.currentItem?.y ?? 0
		radius: root.highlightRadius

		Behavior on y {
			M3NumberAnim { data: Anims.current.effects.fast }
		}
	}

	component Anim: M3NumberAnim {
		data: Anims.current.effects.fast
	}

	add: Transition {
		Anim {
			properties: "opacity,scale"
			from: 0
			to: 1
		}
	}
	remove: Transition {
		enabled: !root.state

		Anim {
			properties: "opacity,scale"
			from: 1
			to: 0
		}
	}
	move: Transition {
		Anim {
			property: "y"
		}
		Anim {
			properties: "opacity,scale"
			to: 1
		}
	}
}
