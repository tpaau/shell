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

	readonly property Item region: loader

	Loader {
		id: activatorLoader

		active: !loader.active
		asynchronous: true

		anchors {
			top: parent.top
		}
		x: (parent.width - width) / 2

		sourceComponent: MouseArea {
			anchors.top: parent.top
			implicitWidth: Config.quickSettings.activatorWidth
			implicitHeight: Config.quickSettings.activatorHeight
			hoverEnabled: true
			onContainsMouseChanged: if (containsMouse) loader.open()
		}
	}

	Loader {
		id: loader

		active: false
		asynchronous: true

		anchors.top: parent.top
		x: (parent.width - width) / 2

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
			}
			x: (parent.width - width) / 2
			implicitHeight: container.height
			implicitWidth: container.width + 4 * radius
			alignment: PopoutAlignment.top

			height: 0
			Component.onCompleted: {
				height = Qt.binding(function() {
					return loader.shouldClose ?
						0 : container.height + 2 * container.spacing
				})
			}
			onHeightChanged: if (height <= 0) loader.active = false

			Behavior on height {
				NumberAnimation {
					duration: Config.animations.durations.popout
					easing.type: Config.animations.easings.popout
				}
			}

			HoverHandler {
				onHoveredChanged: if (!hovered) loader.close()
			}

			RowLayout {
				id: container
				spacing: root.radius

				anchors {
					bottom: parent.bottom
					left: parent.left
					leftMargin: root.radius
					bottomMargin: root.radius
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
							DoNotDisturbButton { spacing: root.radius }
						}
					}

					ColumnLayout {
						Layout.alignment: Qt.AlignTop
						spacing: root.radius / 2
						QSSlider {
							id: sinkSlider
							implicitWidth: grid.width - minWidth
							Layout.leftMargin: minWidth

							readonly property PwNode node: Pipewire.defaultAudioSink
							PwObjectTracker {
								objects: [sinkSlider.node]
							}
							Binding {
								target: sinkSlider
								property: "value"
								when: !sinkSlider.pressed
								value: sinkSlider.node?.audio.volume ?? 0
							}
							onValueChanged: if (node) {
								node.audio.volume = value
							}
							text: ""
							active: value > 0
						}
						QSSlider {
							id: sourceSlider
							implicitWidth: grid.width - minWidth
							Layout.leftMargin: minWidth

							readonly property PwNode node: Pipewire.defaultAudioSource
							PwObjectTracker {
								objects: [sourceSlider.node]
							}
							Binding {
								target: sourceSlider
								property: "value"
								when: !sourceSlider.pressed
								value: sourceSlider.node?.audio.volume ?? 0
							}
							onValueChanged: if (node) {
								node.audio.volume = value
							}
							active: value > 0
							text: active ? "" : ""
						}
						QSSlider {
							implicitWidth: grid.width - minWidth
							Layout.leftMargin: minWidth
							value: S.Brightness.brightness
							to: 100

							property bool ready: false
							onMoved: {
								if (ready) {
									S.Brightness.set(value)
								}
								else {
									ready = true
								}
							}

							text: Icons.pickIcon(value / 100, ["", "", ""])
							active: true
						}
					}

					Item {
						Layout.fillWidth: true
						Layout.fillHeight: true

						SessionButtonGroup {
							anchors {
								right: parent.right
								bottom: parent.bottom
							}
							id: sessionButtons
						}
					}
				}

			}

			MouseArea {
				anchors.fill: container
				propagateComposedEvents: true
				onPressed: (mouse) => {
					mouse.accepted = false
					sessionButtons.closeDialogs()
				}
			}
		}
	}
}
