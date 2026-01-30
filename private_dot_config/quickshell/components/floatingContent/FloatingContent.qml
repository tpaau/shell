pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Io
import qs.components.floatingContent.content
import qs.widgets
import qs.config
import qs.utils

// Displays components in a floating panel while dimming the background.
//
// Items inside of the wrapper can freely change and animate their sizes, it
// should work fine.
Loader {
	id: root

	active: false

	readonly property Item region: status === Loader.Ready ? this : null

	readonly property bool exclusiveFocus: active ? presentedComponent === launcher : false

	anchors.fill: parent

	property bool isClosing: false
	property Component presentedComponent: null
	function open(component: Component): int {
		const status = Utils.checkComponent(component)
		if (status !== 0)
			return status

		isClosing = false
		presentedComponent = component
		active = true

		return 0
	}

	function close(): int {
		if (!active) {
			return 1
		}
		isClosing = true
	}

	IpcHandler {
		target: "floatingContent"

		function toggleLauncher(): int {
			return root.active ? root.close() : root.open(launcher)
		}
		function close(): int {
			return root.close()
		}
	}

	Component {
		id: launcher

		Launcher {
			wrapper: root
		}
	}

	sourceComponent: Rectangle {
		id: background
		color: Qt.alpha(Theme.palette.background, 0.7)
		opacity: 0
		Component.onCompleted: opacity = Qt.binding(() => root.isClosing ? 0 : 1)
		anchors.fill: parent

		Behavior on opacity {
			M3NumberAnim {
				data: Anims.current.effects.fast
			}
		}

		MouseArea {
			anchors.fill: parent
			onClicked: root.close()
		}

		Rectangle {
			id: wrapper
			clip: true

			readonly property int offset: 64

			anchors {
				centerIn: parent
				verticalCenterOffset: offset
				onVerticalCenterOffsetChanged: if (anchors.verticalCenterOffset === -offset)
					root.active = false
			}
			Component.onCompleted: anchors.verticalCenterOffset = Qt.binding(() => root.isClosing ? -offset : 0)
			implicitWidth: loader.width + 2 * radius
			implicitHeight: loader.height + 2 * radius

			color: Theme.palette.background
			radius: Config.rounding.window
			layer.enabled: true
			layer.samples: Config.quality.layerSamples
			layer.effect: StyledShadow {}

			Behavior on anchors.verticalCenterOffset {
				M3NumberAnim {
					data: Anims.current.effects.fast
				}
			}

			MouseArea {
				id: blockingArea
				anchors.fill: parent
			}

			Loader {
				id: loader
				anchors.centerIn: parent
				sourceComponent: root.presentedComponent
			}
		}
	}
}
