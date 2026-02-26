pragma ComponentBehavior: Bound

import QtQuick
import qs.widgets
import qs.services.config

Item {
	id: root
	anchors.fill: parent

	property int radius: Config.rounding.popout

	readonly property Item region: loader.active ? outerAreaLoader : activatorLoader

	Loader {
		id: outerAreaLoader
		anchors.fill: parent
		asynchronous: true
		active: loader.active && Config.quickSettings.closeOnPressedOutside

		sourceComponent: MouseArea {
			anchors.fill: parent
			onPressed: { loader.close() }
		}
	}

	Loader {
		id: activatorLoader

		active: !loader.active
		asynchronous: true

		anchors {
			top: parent.top
			horizontalCenter: parent.horizontalCenter
		}

		sourceComponent: MouseArea {
			anchors.top: parent.top
			implicitWidth: Config.quickSettings.activator.width
			implicitHeight: Config.quickSettings.activator.height
			hoverEnabled: true
			onContainsMouseChanged: if (containsMouse) loader.open()

			Loader {
				anchors.fill: parent
				active: Config.quickSettings.activator.visible
				asynchronous: true

				sourceComponent: Rectangle {
					anchors {
						fill: parent
						topMargin: -height / 2
					}
					radius: Math.min(width, height) / 2
					color: Theme.palette.primary
					opacity: 0
					Component.onCompleted: opacity = 1

					Behavior on opacity {
						M3NumberAnim { data: Anims.current.effects.fast }
					}
				}
			}
		}
	}

	Loader {
		id: loader
		active: false
		asynchronous: true

		anchors {
			top: parent.top
			horizontalCenter: parent.horizontalCenter
		}

		property bool shouldClose: false
		function open() {
			shouldClose = false
			active = true
		}

		function close() {
			shouldClose = true
		}

		sourceComponent: Item {
			id: rect
			implicitWidth: content.implicitWidth + 2 * popout.radius + 2 * popout.margin
			implicitHeight: content.implicitHeight + 2 * popout.margin
			y: -height

			Connections {
				target: loader
				function onShouldCloseChanged(shouldClose: bool) {
					closeAnim.running = true
				}
			}

			PopoutShape {
				id: popout
				anchors {
					fill: parent
					topMargin: -1 -rect.y
				}
				alignment: PopoutShape.Alignment.Top
			}

			M3NumberAnim {
				id: openAnim
				data: Anims.current.spatial.fast
				target: rect
				property: "y"
				from: -rect.height
				to: 0
				running: true
			}

			M3NumberAnim {
				id: closeAnim
				data: Anims.current.effects.fast
				target: rect
				property: "y"
				from: rect.y
				to: -rect.height
				onFinished: loader.active = false
			}

			Behavior on y {
				enabled: !openAnim.running && !closeAnim.running
				M3NumberAnim {
					id: yRestoreAnim
					data: Anims.current.spatial.fast
				}
			}

			MouseArea {
				id: dragArea
				anchors.fill: parent

				property real initialY
				property real prevY
				readonly property real dragDelta: Math.abs(prevY - parent.y)

				drag {
					target: loader.shouldClose
						&& !yRestoreAnim.running
						&& !openAnim.running
						&& !closeAnim.running ? null : parent
					axis: Drag.YAxis
					maximumY: Config.input.maxDrag

					onActiveChanged: {
						if (drag.active) {
							prevY = parent.y
						} else {
							if (dragDelta > Config.quickSettings.dragDismissThreshold) {
								closeAnim.running = true
							} else {
								parent.y = 0
							}
						}
					}
				}
			}

			QSContent {
				id: content
				anchors {
					horizontalCenter: parent.horizontalCenter
					bottom: parent.bottom
					bottomMargin: popout.margin
				}
			}
		}
	}
}
