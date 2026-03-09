pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import qs.widgets
import qs.services.config
import qs.services.config.theme

Menu {
	id: root
	spacing: Config.spacing.smaller
	padding: Config.spacing.small
	margins: padding
	implicitWidth: 180
	focus: false
	clip: true
	delegate: StyledMenuItem {}

	background: Rectangle {
		id: bg
		radius: root.radius
		color: root.color
	}

	contentItem: ListView {
		implicitHeight: contentHeight
		model: root.contentModel
		interactive: implicitHeight > root.implicitHeight - 2 * root.padding
		clip: true
		spacing: root.spacing
	}

	property int radius: Config.rounding.normal
	property int itemSpacing: Config.spacing.small
	property color color: Theme.palette.surface_container

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
