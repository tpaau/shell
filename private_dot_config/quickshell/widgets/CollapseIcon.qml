import QtQuick
import qs.widgets
import qs.config

StyledIcon {
	required property bool expanded

	property alias anim: anim

	text: ""
	rotation: expanded ? 180 : 0

	Behavior on rotation {
		NumberAnimation {
			id: anim
			duration: Config.animations.durations.shorish
			easing.type: Config.animations.easings.fadeOut
		}
	}
}
