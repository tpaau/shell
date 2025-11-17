pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.config
import qs.utils

LazyLoader {
	id: root

	property Component presentedComponent: null

	function open(component: Component): int {
		if (active) return 1
		const status = Utils.checkComponent(component)
		if (status != 0) return status

		shouldClose = false
		loading = true
		presentedComponent = component
		return active ? 0 : 3
	}

	property bool shouldClose: false
	function close() {
		shouldClose = true
	}

	PanelWindow {
		exclusiveZone: 0
		anchors.bottom: true
		color: "transparent"

		implicitWidth: shape.content.width + 4 * Config.rounding.popout
		implicitHeight: shape.content.height + 2 * Config.rounding.popout
			+ Config.shadows.offset

		PopoutShape {
			id: shape
			anchors {
				left: parent.left
				right: parent.right
				bottom: parent.bottom
				bottomMargin: -1
			}
			alignment: PopoutAlignment.bottom

			readonly property QtObject content:
				root.presentedComponent.createObject(this)

			height: 0
			Component.onCompleted: {
				content.x = 2 * Config.rounding.popout
				content.y = Config.rounding.popout
				height = Qt.binding(function() {
					return root.shouldClose ?
						0 : content?.height + 2 * Config.rounding.popout
				})
			}
			onHeightChanged: {
				if (height <= 0) root.active = false
			}

			Behavior on height {
				NumberAnimation {
					duration: Config.animations.durations.popout
					easing.type: Config.animations.easings.popout
				}
			}
		}
	}
}
