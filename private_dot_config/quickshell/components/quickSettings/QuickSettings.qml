pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.widgets
import qs.config
import qs.utils
import qs.services as S

Item {
	id: root

	anchors {
		top: parent.top
		right: parent.right
		left: parent.left
	}

	property int radius: Config.rounding.popout

	readonly property Item region1: loader
	readonly property Item region2: activatorLoader

	readonly property PwNode audioSink: Pipewire.defaultAudioSink
	PwObjectTracker {
		objects: [root.audioSink]
	}

	readonly property PwNode audioSource: Pipewire.defaultAudioSource
	PwObjectTracker {
		objects: [root.audioSource]
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
			onContainsMouseChanged: if (containsMouse)
				loader.open()

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
					color: Theme.palette.accent
					opacity: 0
					Component.onCompleted: opacity = 1

					Behavior on opacity {
						M3NumberAnim {
							data: Anims.current.effects.fast
						}
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

		sourceComponent: PopoutShape {
			id: shape

			anchors {
				top: parent.top
				topMargin: -1
				horizontalCenter: parent.horizontalCenter
			}
			implicitHeight: 0
			implicitWidth: container.implicitWidth + 2 * margin + 2 * radius
			alignment: PopoutAlignment.top

			Component.onCompleted: {
				implicitHeight = Qt.binding(function () {
					return loader.shouldClose ? 0 : container.implicitHeight + 2 * margin
				})
			}
			onHeightChanged: if (height <= 0)
				loader.active = false

			Behavior on implicitHeight {
				M3NumberAnim {
					data: Anims.current.spatial.fast
				}
			}

			HoverHandler {
				id: hover
				onHoveredChanged: if (!hovered)
					loader.close()
			}

			Timer {
				interval: 100
				running: !hover.hovered
				onTriggered: loader.close()
			}

			RowLayout {
				id: container
				spacing: Config.spacing.large

				anchors {
					bottom: parent.bottom
					left: parent.left
					leftMargin: root.radius
					bottomMargin: shape.margin
				}

				MediaControl {}

				ColumnLayout {
					id: grid
					Layout.alignment: Qt.AlignTop
					spacing: root.radius

					ColumnLayout {
						spacing: root.radius
						RowLayout {
							spacing: root.radius
							BluetoothButton {}
							CaffeineButton {}
						}
						RowLayout {
							spacing: root.radius
							DoNotDisturbButton {
								spacing: root.radius
							}
						}
					}

					ColumnLayout {
						Layout.alignment: Qt.AlignTop
						spacing: root.radius

						QSSlider {
							id: sinkSlider

							implicitWidth: grid.width

							Binding {
								target: sinkSlider
								property: "value"
								when: !sinkSlider.pressed
								value: root.audioSink?.audio.volume ?? 0
							}
							onValueChanged: if (root.audioSink) {
								root.audioSink.audio.volume = value
							}
							text: ""
						}
						QSSlider {
							id: sourceSlider

							implicitWidth: grid.width

							Binding {
								target: sourceSlider
								property: "value"
								when: !sourceSlider.pressed
								value: root.audioSource?.audio.volume ?? 0
							}
							onValueChanged: if (root.audioSource) {
								root.audioSource.audio.volume = value
							}
							text: value > 0 ? "" : ""
						}
						QSSlider {
							id: brightnessSlider

							implicitWidth: grid.width
							to: 100

							Binding {
								target: brightnessSlider
								property: "value"
								when: !brightnessSlider.pressed
								value: S.Brightness.brightness
							}

							property bool ready: false
							onMoved: {
								if (ready) {
									S.Brightness.set(value)
								} else {
									ready = true
								}
							}

							text: Icons.pickIcon(value / 100, ["", "", ""])
						}
					}

					Item {
						Layout.fillWidth: true
						Layout.fillHeight: true

						SessionButtonGroup {
							id: sessionButtons
							anchors {
								right: parent.right
								bottom: parent.bottom
							}
						}
					}
				}
			}

			MouseArea {
				anchors.fill: container
				propagateComposedEvents: true
				onPressed: mouse => {
					mouse.accepted = false
					sessionButtons.closeDialogs()
				}
			}
		}
	}
}
