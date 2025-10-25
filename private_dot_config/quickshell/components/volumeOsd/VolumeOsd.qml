pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.config
import qs.widgets
import qs.utils
import qs.animations
import qs.widgets.popout

Item {
	id: root

	readonly property int rounding: Config.rounding.popout
	property int popoutWidth: 60 + 2 * rounding
	property int popoutHeight: 400 + 2 * rounding

	PwObjectTracker {
		objects: [Pipewire.defaultAudioSink]
	}

	Connections {
		target: Pipewire.defaultAudioSink?.audio ?? null

		function onVolumeChanged() {
			popoutLoader.loading = true
		}
	}

	LazyLoader {
		id: activatorLoader
		loading: true

		PanelWindow {
			anchors.right: true
			exclusiveZone: 0

			implicitWidth: 0
			implicitHeight: root.popoutHeight
			color: "transparent"

			HoverHandler {
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
			anchors.right: true
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
					right: parent.right
				}
				implicitWidth: 0

				Component.onCompleted: {
					implicitWidth = root.popoutWidth
					opened = true
				}

				Behavior on implicitWidth {
					PopoutAnimation {}
				}

				RightPopoutShape {
					radius: root.rounding
					width: shape.width
					height: shape.height
				}

				SimpleSlider {
					id: volumeSlider

					anchors {
						left: parent.left
						top: parent.top
						bottom: parent.bottom
						topMargin: 2 * root.rounding
						bottomMargin: 2 * root.rounding
						leftMargin: root.rounding
					}
					implicitWidth: root.popoutWidth - 2 * root.rounding

					orientation: Qt.Vertical

					value: Pipewire.defaultAudioSink?.audio.volume ?? 0
					onValueChanged: {
						if (Pipewire.defaultAudioSink != null) {
							Pipewire.defaultAudioSink.audio.volume = value
						}
					}

					StyledText {
						anchors.centerIn: volumeSlider.handle
						visible: volumeSlider.pressed
						color: Theme.pallete.bg.c3
						text: {
							let defaultSink = Pipewire.defaultAudioSink
							if (defaultSink == null) {
								return "0"
							}
							else {
								let volume = defaultSink?.audio.volume ?? 0
								return Math.round((volume * 100))
									.toString();
							}
						}
					}

					StyledIcon {
						anchors.centerIn: volumeSlider.handle
						visible: !volumeSlider.pressed
						color: Theme.pallete.bg.c3
						text: {
							let defaultSink = Pipewire.defaultAudioSink
							let volume = defaultSink?.audio.volume ?? 0
							if (volume == 0) {
								""
							}
							else {
								return Icons.pickIcon(volume, ["", "", ""])
							}
						}
					}
				}
			}
		}
	}
}
