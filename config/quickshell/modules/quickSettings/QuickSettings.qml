pragma ComponentBehavior: Bound


import QtQuick
import Quickshell
import qs.widgets
import qs.theme
import qs.config
import qs.services
import qs.services.niri

Item {
	id: root
	anchors.fill: parent

	required property ShellScreen screen
	readonly property bool hideEntirely:
		Niri.outputFromShellScreen(screen)?.hasFullscreenWindowFocused
		|| Ipc.sessionManagementList.find(s => s.screen === screen)?.opened
		|| Ipc.floatingContentList.find(c => c.screen === screen)?.opened
	onHideEntirelyChanged: if (hideEntirely) {
		loader.close()
	}

	property int radius: Config.rounding.popout

	readonly property Item region: loader.status === Loader.Ready ? outerAreaLoader : activatorLoader
	readonly property bool opened: loader.active

	Component.onCompleted: Ipc.quickSettingsList.push(this)

	Loader {
		id: outerAreaLoader
		anchors.fill: parent
		asynchronous: true
		active: loader.active && Config.quickSettings.closeOnPressedOutside

		sourceComponent: MouseArea {
			anchors.fill: parent
			onPressed: (mouse) => {
				mouse.accepted = false
				loader.close()
			}
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
			onContainsMouseChanged:
				if (containsMouse && !root.hideEntirely) loader.open()

			Loader {
				anchors.fill: parent
				active: Config.quickSettings.activator.visible
				asynchronous: true

				sourceComponent: Rectangle {
					id: activatorRect
					anchors {
						fill: parent
						topMargin: -height / 2
					}
					radius: height / 2
					color: Theme.palette.primary
					opacity: 0
					Component.onCompleted: opacity = Qt.binding(() => {
						return root.hideEntirely ? 0.0 : 1.0
					})

					Behavior on opacity { M3NumberAnim { data: Anims.current.effects.regular } }
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
			id: wrapper
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
					topMargin: -1 -wrapper.y
				}
				alignment: PopoutShape.Alignment.Top
			}

			M3NumberAnim {
				id: openAnim
				data: Anims.current.spatial.fast
				target: wrapper
				property: "y"
				from: wrapper.y
				to: 0
				running: true
			}

			M3NumberAnim {
				id: closeAnim
				data: Anims.current.effects.fast
				target: wrapper
				property: "y"
				from: wrapper.y
				to: -wrapper.height
				onFinished: loader.active = false
			}

			MouseArea {
				id: dragArea
				anchors.fill: parent

				property real prevY
				readonly property real dragDelta: Math.abs(prevY - parent.y)

				drag {
					target: loader.shouldClose
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
								openAnim.restart()
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
