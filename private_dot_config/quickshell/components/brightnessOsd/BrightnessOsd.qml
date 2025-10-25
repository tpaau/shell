pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.widgets
import qs.animations
import qs.widgets.popout
import qs.utils

Item {
	id: root

	readonly property int rounding: Config.rounding.popout
	property int popoutWidth: 60 + 2 * rounding
	property int popoutHeight: 400 + 2 * rounding

	LazyLoader {
		id: activatorLoader
		loading: true

		PanelWindow {
			anchors.left: true
			exclusiveZone: 0

			implicitWidth: 0
			implicitHeight: root.popoutHeight
			color: "transparent"

			HoverHandler {
				id: edgeArea
				onHoveredChanged: if (hovered) popoutLoader.loading = true
			}
		}
	}

	LazyLoader {
		id: popoutLoader

		onActiveChanged: {
			if (active) {
				activatorLoader.active = false
			}
			else {
				activatorLoader.loading = true
			}
		}

		PanelWindow {
			implicitWidth: root.popoutWidth + Config.shadows.blur
			implicitHeight: root.popoutHeight
			anchors.left: true
			exclusiveZone: 0
			color: "transparent"

			Timer {
				id: hideTimer
				interval: ShellBehavior.popout.timeout
				onTriggered: shape.implicitWidth = 0
				running: true
			}

			HoverHandler {
				onHoveredChanged: {
					if (hovered) {
						hideTimer.stop()
						shape.implicitWidth = root.popoutWidth
						shape.opened = true
					}
					else {
						hideTimer.restart()
						shape.opened = false
					}
				}
			}

			StyledPopoutShape {
				id: shape

				property bool opened: true
				onImplicitWidthChanged: if (implicitWidth <= 0 && !opened) {
					popoutLoader.active = false
				}

				anchors {
					top: parent.top
					bottom: parent.bottom
					left: parent.left
					leftMargin: -1
				}
				implicitWidth: 0

				Component.onCompleted: {
					implicitWidth = root.popoutWidth
					opened = true
				}

				Behavior on implicitWidth {
					PopoutAnimation {}
				}

				LeftPopoutShape {
					radius: root.rounding
					width: shape.width
					height: shape.height
				}

				SimpleSlider {
					id: brightnessSlider
					implicitWidth: root.popoutWidth - 2 * root.rounding

					anchors {
						right: parent.right
						top: parent.top
						bottom: parent.bottom
						topMargin: 2 * root.rounding
						bottomMargin: 2 * root.rounding
						rightMargin: root.rounding
					}

					orientation: Qt.Vertical

					property bool ready: false
					onValueChanged: {
						if (ready) {
							setBrightnessProc.running = true
						}
						else {
							ready = true
						}
					}

					Process {
						id: setBrightnessProc
						command: ["brightnessctl", "s",
							Math.max(1, Math.round(brightnessSlider.value * 100)) + "%"]
					}

					Process {
						id: backglightProc
						running: true

						command: ["brightnessctl", "-P", "g"]

						stdout: StdioCollector {
							onStreamFinished: {
								let value = parseInt(text.trim()) / 100
								if (value <= 0.01) {
									brightnessSlider.value = 0
								}
								else {
									brightnessSlider.value = value
								}
							}
						}
					}

					StyledText {
						anchors.centerIn: brightnessSlider.handle
						visible: brightnessSlider.pressed
						color: Theme.pallete.bg.c3
						text: {
							let brightness = brightnessSlider.value
							Math.max(1, Math.round((brightness * 100))).toString()
						}
					}

					StyledIcon {
						anchors.centerIn: brightnessSlider.handle
						visible: !brightnessSlider.pressed
						color: Theme.pallete.bg.c3
						font.pixelSize: Config.icons.size.small
						text: {
							let brightness = brightnessSlider.value
							Icons.pickIcon(brightness, ["", "", "", "", "", "", ""])
						}
					}
				}
			}
		}
	}
}
