pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.widgets
import qs.widgets.popout
import qs.config

LazyLoader {
	id: root

	property Component presentedComponent: null

	// Return values:
	//   - 0: Success
	//   - 1: General failure
	//   - 2: Given component value wasn't truthy
	//   - 3: Given component status was not `Component.Ready`
	function open(component: Component): int {
		if (active) return 1
		else if (!component) {
			console.warn("The given component was null/undefined!")
			return 2
		}
		else if (component.status !== Component.Ready) {
			console.warn("The given component was invalid or not ready!")
			return 3
		}

		shouldClose = false
		loading = true
		presentedComponent = component
		return 0
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

		StyledPopoutShape {
			id: shape

			readonly property QtObject content:
				root.presentedComponent.createObject(this)

			anchors {
				left: parent.left
				right: parent.right
				bottom: parent.bottom
				bottomMargin: -1
			}

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

			layer.enabled: true
			layer.samples: Config.quality.layerSamples
			layer.effect: StyledShadow {}

			BottomPopoutShape {
				width: shape.width
				height: shape.height
				radius: Config.rounding.popout
			}
		}
	}
}
