pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import qs.config
import qs.widgets

Menu {
	id: root
	spacing: Config.spacing.smaller
	padding: Config.spacing.small
	implicitWidth: 180

	delegate: StyledMenuItem {}

	property int radius: Config.rounding.normal
	property int itemSpacing: Config.spacing.small
	property color color: Theme.palette.surfaceBright

	background: Rectangle {
		id: bg
		radius: root.radius
		color: root.color
	}

	contentItem: ListView {
		implicitHeight: contentHeight
		model: root.contentModel
		clip: true
		spacing: root.spacing
	}

	component SpatialAnim: M3NumberAnim { data: Anims.current.spatial.fast }
	component Anim: M3NumberAnim { data: Anims.current.effects.fast }

	enter: Transition {
		Anim {
			property: "opacity"
			from: 0
			to: 1
		}
		SpatialAnim {
			property: "scale"
			from: 0.95
			to: 1
		}
	}

	exit: Transition {
		Anim {
			property: "opacity"
			from: 1
			to: 0
		}
		SpatialAnim {
			property: "scale"
			from: 1
			to: 0.95
		}
	}
}
