pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.services.config

ScrollView {
	id: root

	property int rounding: Config.rounding.small

	contentItem.layer.enabled: true
	contentItem.layer.effect: MultiEffect {
		maskEnabled: true
		maskSpreadAtMin: 1
		maskThresholdMin: 0.5
		maskSource: Rectangle {
			parent: root
			visible: false
			radius: root.rounding
			layer.enabled: true
			anchors.fill: root
		}
	}
}
