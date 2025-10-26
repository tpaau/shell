pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.widgets
import qs.widgets.mediaControl as MC
import qs.animations
import qs.widgets.popout
import qs.config
import qs.utils
import qs.services

LazyLoader {
	id: root

	property int radius: Config.rounding.popout

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
		exclusionMode: ExclusionMode.Ignore
		color: "transparent"

		implicitWidth: container.implicitWidth + 4 * root.radius
		implicitHeight: container.height
			+ Config.statusBar.size
			+ Config.shadows.blur
			+ 2 * container.spacing

		StyledPopoutShape {
			id: shape

			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
				topMargin: Config.statusBar.size
			}

			height: 0
			Component.onCompleted: {
				height = Qt.binding(function() {
					return root.shouldClose ?
						0 : container.height + 2 * container.spacing
				})
			}
			onHeightChanged: if (height <= 0) root.active = false

			Behavior on height {
				PopoutAnimation {}
			}

			layer.enabled: true
			layer.samples: Config.quality.layerSamples
			layer.effect: StyledShadow {
				autoPaddingEnabled: false
				paddingRect: Qt.rect(
					0,
					0,
					parent.width,
					parent.height)
			}

			TopPopoutShape {
				width: shape.width
				height: shape.height
				radius: Config.rounding.popout
			}

			RowLayout {
				id: container
				spacing: root.radius

				anchors {
					left: parent.left
					right: parent.right
					bottom: parent.bottom
					leftMargin: 2 * root.radius
					rightMargin: 2 * root.radius
					bottomMargin: root.radius
				}

				MC.MediaControl {}

				ColumnLayout {
					id: grid
					Layout.alignment: Qt.AlignTop
					spacing: root.radius

					GridLayout {
						columns: 2
						rowSpacing: root.radius
						columnSpacing: rowSpacing
						Layout.alignment: Qt.AlignTop

						QSBluetoothButton {}
						CaffeineButton {}
					}

					ColumnLayout {
						Layout.alignment: Qt.AlignTop
						spacing: root.radius / 2
						QSSlider {
							id: sinkSlider
							implicitWidth: grid.width
							readonly property PwNode node: Pipewire.defaultAudioSink
							PwObjectTracker {
								objects: [sinkSlider.node]
							}
							value: node?.audio.volume ?? 0
							onValueChanged: if (node) {
								node.audio.volume = value
							}
							text: ""
						}
						QSSlider {
							id: sourceSlider
							implicitWidth: grid.width
							readonly property PwNode node: Pipewire.defaultAudioSource
							PwObjectTracker {
								objects: [sourceSlider.node]
							}
							value: node?.audio.volume ?? 0
							onValueChanged: if (node) {
								node.audio.volume = value
							}
							text: ""
						}
						QSSlider {
							implicitWidth: grid.width
							value: Brightness.brightness
							to: 100

							text: Icons.pickIcon(value, ["", "", ""])

							property bool ready: false
							onMoved: {
								if (ready) {
									Brightness.set(value)
								}
								else {
									ready = true
								}
							}
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

		HoverHandler {
			onHoveredChanged: if (!hovered) root.close()
		}
	}
}
