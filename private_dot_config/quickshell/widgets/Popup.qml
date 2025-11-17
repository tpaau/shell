pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.config

Loader {
	id: root

	active: false
	asynchronous: true

	anchors {
		verticalCenter: parent.verticalCenter
		horizontalCenter: parent.horizontalCenter
	}

	required property Component component

	property bool isClosing: false
	function open(): int {
		isClosing = false
		active = true
		return active ? 0 : 3
	}

	function close() {
		isClosing = true
		active = false
	}

	sourceComponent: Rectangle {
		id: rect

		radius: Config.rounding.normal
		color: Theme.palette.background
		layer.enabled: true
		layer.samples: Config.quality.layerSamples
		layer.effect: StyledShadow {}

		MarginWrapperManager { margin: rect.radius }

		Loader {
			id: contentLoader
			anchors.centerIn: parent
			asynchronous: true
			sourceComponent: root.component
		}
	}
}
