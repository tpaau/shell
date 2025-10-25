import QtQuick
import qs.config

ColorAnimation {
	duration: Config.animations.durations.shorter
	easing.type: Config.animations.easings.colorTransition
}
