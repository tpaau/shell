pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import qs.widgets
import qs.config
import qs.services

Item {
	id: root

	readonly property color background: Theme.pallete.bg.c1
	property color dimColor: Qt.alpha(
		background, 0.7)

	readonly property int spacing: Config.spacing.larger
	readonly property int buttonSize: 128

	IpcHandler {
		id: ipc
		target: "sessionManagement"

		function open() {
			console.debug("Opening session management")
			loader.loading = true
		}
	}

	LazyLoader {
		id: loader

		PanelWindow {
			id: win
			exclusionMode: ExclusionMode.Ignore
			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

			property bool opened: false
			Component.onCompleted: opened = true

			function close() {
				opened = false
				closeTimer.running = true
				mainRect.fadeOffset = -64
			}

			readonly property int fadeEasing: Config.animations.easings.fadeIn
			readonly property int fadeInterval: Config.animations.durations.shorter

			anchors {
				top: true
				left: true
				bottom: true
				right: true
			}

			color: "transparent"

			Timer {
				id: closeTimer
				interval: win.fadeInterval
				onTriggered: loader.active = false
			}

			Item {
				id: contentItem
				focus: true

				property Button activeButton: topLeft
				function activateButton(button: Button) {
					if (button != null) {
						activeButton.focused = false
						activeButton = button
						activeButton.focused = true
					}
				}

				Keys.onPressed: event => {
					if (event.key == Qt.Key_Escape) win.close();
					else if (event.key == Qt.Key_Right) {
						activateButton(activeButton.goRight)
					}
					else if (event.key == Qt.Key_Left) {
						activateButton(activeButton.goLeft)
					}
					else if (event.key == Qt.Key_Up) {
						activateButton(activeButton.goUp)
					}
					else if (event.key == Qt.Key_Down) {
						activateButton(activeButton.goDown)
					}
					else if (event.key == Qt.Key_Return) {
						activeButton.clicked(null)
					}
				}
			}

			Rectangle {
				id: dialogRect

				color: root.dimColor
				anchors.fill: parent

				MouseArea {
					anchors.fill: parent
					onClicked: win.close()
				}

				opacity: win.opened? 1 : 0

				Behavior on opacity {
					NumberAnimation {
						easing.type: win.fadeEasing
						duration: win.fadeInterval
					}
				}

				Rectangle {
					id: mainRect

					anchors.centerIn: parent
					property int fadeOffset: 64
					anchors.verticalCenterOffset: fadeOffset
					Behavior on anchors.verticalCenterOffset {
						NumberAnimation {
							easing.type: win.fadeEasing
							duration: win.fadeInterval
						}
					}

					Component.onCompleted: fadeOffset = 0

					color: Theme.pallete.bg
					radius: Config.rounding.large
					layer.enabled: true
					layer.samples: Config.quality.layerSamples
					layer.effect: StyledShadow { }

					MarginWrapperManager {
						margin: root.spacing
					}

					GridLayout {
						rowSpacing: root.spacing
						columnSpacing: root.spacing
						columns: 2

						Button {
							id: topLeft
							goRight: topRight
							goDown: bottomLeft
							onClicked: {
								Session.poweroff()
								win.close()
							}
							icon: ""

							focused: true
						}
						Button {
							id: topRight
							goLeft: topLeft
							goDown: bottomRight
							onClicked: {
								Session.reboot()
								win.close()
							}
							icon: ""
						}
						Button {
							id: bottomLeft
							goRight: bottomRight
							goUp: topLeft
							onClicked: {
								Session.lock()
								win.close()
							}
							icon: ""
						}
						Button {
							id: bottomRight
							goLeft: bottomLeft
							goUp: topRight
							onClicked: {
								Session.logout()
								win.close()
							}
							icon: ""
						}
					}

					component Button: StyledButton {
						id: button

						property Button goLeft: null
						property Button goRight: null
						property Button goUp: null
						property Button goDown: null

						property alias icon: styledIcon.text

						property bool focused: false

						implicitWidth: root.buttonSize
						implicitHeight: root.buttonSize
						rect.radius: root.buttonSize / 2

						regularColor: focused ?
							hoveredColor : Theme.pallete.bg.c3
						hoveredColor: Theme.pallete.bg.c5
						pressedColor: Theme.pallete.bg.c7

						onEntered: contentItem.activateButton(this)

						StyledIcon {
							anchors.centerIn: parent
							font.pixelSize: Config.icons.size.larger
							id: styledIcon
						}
					}

					component ButtonIcon: StyledText {
						font.pixelSize: root.buttonSize / 4
						anchors.centerIn: parent
					}
				}
			}
		}
	}
}
