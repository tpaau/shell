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
	anchors.fill: parent

	readonly property Item region: loader.active ? this : null
	readonly property int spacing: Config.spacing.larger
	readonly property int buttonSize: Config.sessionManagement.buttonSize
	readonly property int offset: 64
	readonly property bool exclusiveFocus: loader.active

	component Anim: M3NumberAnim { data: Anims.current.effects.fast }

	IpcHandler {
		target: "sessionManagement"

		function open(): int {
			if (loader.active) return 1
			else loader.active = true
		}
		function close(): int {
			if (loader.active) {
				loader.isClosing = true
				return 0
			}
			return 1
		}
		function toggleOpen() {
			if (loader.active && !loader.isClosing) {
				loader.isClosing = true
			} else {
				loader.active = true
			}
		}
	}

	Loader {
		id: loader
		anchors.fill: parent
		active: false
		asynchronous: true
		focus: true

		property bool isClosing: false

		sourceComponent: Rectangle {
			id: bg
			anchors.fill: parent
			focus: true
			onFocusChanged: focus = true
			layer.enabled: true
			color: Qt.alpha(Theme.palette.background, 0.7)

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
					closeAnim.running = true
				} else if (event.key === Qt.Key_Right) {
					activateButton(activeButton.goRight)
				} else if (event.key === Qt.Key_Left) {
					activateButton(activeButton.goLeft)
				} else if (event.key === Qt.Key_Up) {
					activateButton(activeButton.goUp)
				} else if (event.key === Qt.Key_Down) {
					activateButton(activeButton.goDown)
				} else if (event.key === Qt.Key_Return) {
					activeButton.clicked(null)
				}
			}

			Anim {
				id: openAnim
				running: true
				properties: "opacity"
				target: bg
				from: 0
				to: 1
			}

			Anim {
				id: closeAnim
				properties: "opacity"
				target: bg
				from: bg.opacity
				to: 0
				onStarted: {
					openAnim.stop()
					rectCloseAnim.running = true
				}
				onFinished: {
					loader.isClosing = false
					loader.active = false
				}
			}

			Connections {
				target: loader

				function onIsClosingChanged() {
					if (loader.isClosing) closeAnim.running = true
				}
			}

			component ButtonIcon: StyledText {
				font.pixelSize: root.buttonSize / 4
				anchors.centerIn: parent
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

				onEntered: bg.activateButton(this)

				StyledIcon {
					id: styledIcon
					anchors.centerIn: parent
					font.pixelSize: Config.icons.size.larger
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: closeAnim.running = true
			}

			Rectangle {
				id: contentRect
				anchors.centerIn: parent
				implicitWidth: grid.implicitWidth + 2 * root.spacing
				implicitHeight: grid.implicitHeight + 2 * root.spacing
				layer.enabled: true
				layer.effect: StyledShadow {}
				layer.samples: Config.quality.layerSamples
				radius: Config.rounding.large
				color: Theme.palette.background

				Anim {
					id: rectOpenAnim
					running: true
					target: contentRect
					properties: "anchors.verticalCenterOffset"
					from: root.offset
					to: 0
				}

				Anim {
					id: rectCloseAnim
					target: contentRect
					properties: "anchors.verticalCenterOffset"
					from: contentRect.anchors.verticalCenterOffset
					to: -root.offset
					onStarted: rectOpenAnim.stop()
				}

				GridLayout {
					id: grid
					anchors.centerIn: parent
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
			}
		}
	}
}
