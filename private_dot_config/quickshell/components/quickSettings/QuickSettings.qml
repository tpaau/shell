pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.widgets
import qs.config
import qs.utils
import qs.services as S

Item {
	id: root
	property int radius: Config.rounding.popout

	readonly property bool opened: loader.active

	LazyLoader {
		id: activatorLoader
		loading: true

		PanelWindow {
			exclusionMode: ExclusionMode.Ignore
			implicitWidth: Config.quickSettings.activatorWidth
			implicitHeight: Config.quickSettings.activatorHeight
			color: "transparent"

			anchors {
				top: true
			}

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				onContainsMouseChanged: if (containsMouse) loader.open()
			}
		}
	}

	LazyLoader {
		id: loader

		property bool shouldClose: false
		function open() {
			shouldClose = false
			loading = true
		}

		function close() {
			shouldClose = true
		}

		PanelWindow {
			id: window
			anchors.top: true
			exclusiveZone: 0
			exclusionMode: ExclusionMode.Ignore
			color: "transparent"

			implicitWidth: container.implicitWidth + 4 * root.radius
			implicitHeight: container.height
				+ Config.statusBar.size

			HoverHandler {
				onHoveredChanged: if (!hovered) loader.close()
			}

			PopoutShape {
				id: shape
				anchors {
					left: parent.left
					right: parent.right
					top: parent.top
					topMargin: -1
				}
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

				RowLayout {
					id: container
					spacing: root.radius

					anchors {
						left: parent.left
						right: parent.right
						bottom: parent.bottom
						leftMargin: root.radius
						rightMargin: root.radius
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
}
