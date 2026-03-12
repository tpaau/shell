import QtQuick
import qs.widgets
import qs.config

StyledIcon {
	required property bool expanded

	property alias anim: anim

	text: ""
	rotation: expanded ? 180 : 0

	Behavior on rotation {
		M3NumberAnim {
			id: anim
			data: Anims.current.effects.fast
		}
	}
}
