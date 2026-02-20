pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import qs.widgets
import qs.services
import qs.services.config

Item {
	id: root

	readonly property int spacing: Config.spacing.larger
	readonly property int buttonSize: Config.sessionManagement.buttonSize

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
			anchors {
				top: true
				left: true
				bottom: true
				right: true
			}

			exclusionMode: ExclusionMode.Ignore
			WlrLayershell.layer: WlrLayer.Overlay
			WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

			property bool opened: false
			Component.onCompleted: opened = true

			function close() {
				opened = false
				closeTimer.restart()
				mainRect.fadeOffset = -64
			}

			color: "transparent"

			Timer {
				id: closeTimer
				interval: Anims.current.effects.fast.duration
				onTriggered: loader.active = false
			}

			Item {
				id: contentItem
				focus: true

				property Button activeButton: topLeft
				function activateButton(button: Button) {
					if (button) {
						activeButton.focused = false
						activeButton = button
						activeButton.focused = true
					}
				}

				Keys.onPressed: event => {
					if (event.key === Qt.Key_Escape) {
						win.close()
					}
					else if (event.key === Qt.Key_Right) {
						activateButton(activeButton.goRight)
					}
					else if (event.key === Qt.Key_Left) {
						activateButton(activeButton.goLeft)
					}
					else if (event.key === Qt.Key_Up) {
						activateButton(activeButton.goUp)
					}
					else if (event.key === Qt.Key_Down) {
						activateButton(activeButton.goDown)
					}
					else if (event.key === Qt.Key_Return) {
						activeButton.clicked(null)
					}
				}
			}

			Rectangle {
				id: dialogRect
				anchors.fill: parent

				color: Qt.alpha(Theme.palette.background, 0.7)
				opacity: win.opened ? 1 : 0

				MouseArea {
					anchors.fill: parent
					onClicked: win.close()
				}

				Behavior on opacity {
					M3NumberAnim { data: Anims.current.effects.fast }
				}

				Rectangle {
					id: mainRect
					anchors.centerIn: parent

					color: Theme.palette.background
					radius: Config.rounding.large
					layer.enabled: true
					layer.samples: Config.quality.layerSamples
					layer.effect: StyledShadow {}

					property int fadeOffset: 64
					Component.onCompleted: fadeOffset = 0
					anchors.verticalCenterOffset: fadeOffset

					Behavior on anchors.verticalCenterOffset {
						M3NumberAnim { data: Anims.current.effects.fast }
					}

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

						property bool focused: false
						property Button goLeft: null
						property Button goRight: null
						property Button goUp: null
						property Button goDown: null

						property alias icon: styledIcon.text

						implicitWidth: root.buttonSize
						implicitHeight: root.buttonSize
						rect.radius: root.buttonSize / 2

						theme: StyledButton.Theme.Surface
						regularColor: focused ?
							hoveredColor : Theme.palette.surface

						onEntered: contentItem.activateButton(this)

						StyledIcon {
							id: styledIcon
							anchors.centerIn: parent
							font.pixelSize: Config.icons.size.larger
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
