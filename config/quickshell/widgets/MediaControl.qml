pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.models
import qs.widgets
import qs.utils
import qs.services
import qs.config
import qs.theme

Rectangle {
	id: root

	property int orientation: MediaControl.Vertical
	readonly property int margin: Config.spacing.small

	enum Orientation {
		Horizontal,
		Vertical
	}

	clip: true
	radius: Config.rounding.large
	color: Theme.palette.surface_container_low

	implicitWidth: mainLayout.implicitWidth + 2 * root.margin
	implicitHeight: mainLayout.implicitHeight + 2 * root.margin

	GridLayout {
		id: mainLayout
		anchors.centerIn: parent
		rowSpacing: root.margin
		columnSpacing: root.margin
		flow: switch (root.orientation) {
			case MediaControl.Horizontal:
				return GridLayout.LeftToRight
			case MediaControl.Vertical:
				return GridLayout.TopToBottom
			default :
				return GridLayout.LeftToRight
		}

		ClippingRectangle {
			implicitWidth: Math.min(parent.width, parent.height)
			implicitHeight: Math.min(parent.width, parent.height)
			radius: root.radius - root.margin
			color: Theme.palette.surface_container_high

			StyledIcon {
				anchors.centerIn: parent
				font.pixelSize: Config.icons.size.larger
				visible: (!coverArt.source || coverArt.source == "")
					&& coverArt.status !== Image.Ready
				theme: StyledIcon.Theme.RegularDim
				text: "image"
			}

			Image {
				id: coverArt
				anchors.fill: parent

				onStatusChanged: {
					if (status === Image.Ready) {
						opacityAnim.enabled = true
						opacity = 1
					} else {
						opacityAnim.enabled = false
						opacity = 0
					}
				}
				asynchronous: true
				sourceSize.width: width
				sourceSize.height: height
				fillMode: Image.PreserveAspectCrop
				source: MprisService.getArtUrl()

				Behavior on opacity {
					id: opacityAnim
					M3NumberAnim { data: Anims.current.spatial.fast }
				}
			}
		}

		ColumnLayout {
			id: controlLayout
			spacing: mainLayout.rowSpacing

			DropDownMenu {
				id: menu
				entries: []
				noEntriesText: "No players"
				Layout.alignment: Qt.AlignCenter

				onEntriesChanged: if (entries.length === Mpris.players.values.length) {
					const entry = entries.find(e => e.modelData === MprisService.player)
					if (entry) {
						selectItem(entries.indexOf(entry))
					}
				}

				Instantiator {
					model: Mpris.players.values
					delegate: DropDownMenuEntry {
						required property int index
						required property MprisPlayer modelData
						name: modelData?.identity ?? `Player ${index}`

						onSelected: if (modelData) {
							MprisService.player = modelData
						}
					}

					onObjectAdded: (index, object) => {
						menu.entries.push(object)
					}

					onObjectRemoved: (index, object) => {
						const idx = menu.entries.indexOf(object)
						if (idx > -1) {
							menu.entries.splice(idx, 1)
						}
					}
				}
			}

			ColumnLayout {
				StyledTextWithMetrics {
					text: {
						if (MprisService.player?.trackTitle && MprisService.player.trackTitle != "") {
							return MprisService.player?.trackTitle
						}
						return "Unknown"
					}
					font.pixelSize: Config.font.size.large
					font.weight: Config.font.weight.heavy
					Layout.preferredWidth: controlLayout.width
					elide: Text.ElideRight

					// Make sure the height stays the same when rendering fun characters
					Layout.preferredHeight: fontMetrics.height
				}
				StyledTextWithMetrics {
					text: {
						if (MprisService.player?.trackArtist && MprisService.player.trackArtist != "") {
							return MprisService.player?.trackArtist
						}
						return "Unknown"
					}
					font.pixelSize: Config.font.size.small
					Layout.preferredWidth: controlLayout.width
					elide: Text.ElideRight
					Layout.preferredHeight: fontMetrics.height
				}
			}

			StyledSlider {
				id: seekSlider
				implicitWidth: parent.width
				focusPolicy: Qt.NoFocus
				enabled: MprisService.player?.canSeek ?? false

				onPressedChanged: if (!pressed) {
					MprisService.player.position = value * MprisService.player.length
				}

				Binding {
					target: seekSlider
					property: "value"
					when: !seekSlider.pressed
					value: Math.min(
						(MprisService.player?.position ?? 0) / (MprisService.player?.length ?? 1), 1
					)
				}
			}

			RowLayout {
				Layout.preferredWidth: parent.width

				StyledText {
					Layout.alignment: Qt.AlignLeft
					Layout.preferredHeight: Math.floor(implicitHeight) & ~1
					text: MprisService.player ?
						Utils.formatHMS(Math.min(
							seekSlider.value * MprisService.player.length,
							MprisService.player.length))
						: "--:--"
					font.pixelSize: Config.font.size.smaller
					theme: seekSlider.pressed ?
						StyledText.Theme.Regular : StyledText.Theme.RegularDim
				}
				StyledText {
					Layout.alignment: Qt.AlignRight
					Layout.preferredHeight: Math.floor(implicitHeight) & ~1
					text: MprisService.player ?
						Utils.formatHMS(MprisService.player.length) : "--:--"
					font.pixelSize: Config.font.size.smaller
					theme: StyledText.Theme.RegularDim
				}
			}

			RowLayout {
				id: buttonLayout
				spacing: root.margin
				Layout.alignment: Qt.AlignCenter

				IconButton {
					id: loopButton
					implicitWidth: 34
					implicitHeight: 34
					enabled: MprisService.player?.loopSupported ?? false
					theme: active ? StyledButton.Tertiary : StyledButton.TertiaryInactive

					readonly property bool active: enabled
						&& MprisService.player.loopState !== MprisLoopState.None

					onClicked: {
						const player = MprisService.player
						if (player.loopState === MprisLoopState.None) {
							player.loopState = MprisLoopState.Track
						} else if (player.loopState === MprisLoopState.Track) {
							player.loopState = MprisLoopState.Playlist
						} else {
							player.loopState = MprisLoopState.None
						}
					}

					icon {
						font.weight: loopButton.active ?
								Config.font.weight.regular : Config.font.weight.light
						text: MprisService.player?.loopState !== MprisLoopState.Track ?
							"repeat" : "repeat_one"
					}
				}
				IconButton {
					id: previousButton
					implicitWidth: 40
					implicitHeight: 40
					theme: StyledButton.Secondary
					enabled: MprisService.player?.canGoPrevious ?? false
					icon.text: "skip_previous"

					onClicked: if (MprisService.player?.canGoPrevious) {
						MprisService.player.previous()
					}
				}
				IconButton {
					id: playPauseButton
					implicitWidth: 50
					implicitHeight: 50
					enabled: (MprisService.player?.canPlay ?? false)
						|| (MprisService.player?.canPause ?? false)
					radius: MprisService.player?.isPlaying ?
						Math.min(width, height) / 3
						: Math.min(width, height) / 2
					theme: StyledButton.Theme.Primary

					onClicked: if (MprisService.player?.canPause) {
						MprisService.player.togglePlaying()
					}

					icon {
						font.pixelSize: Config.icons.size.large
						text: MprisService.playbackIcon
					}
				}
				IconButton {
					id: nextButton
					implicitWidth: 40
					implicitHeight: 40
					enabled: MprisService.player?.canGoNext ?? false
					theme: StyledButton.Theme.Secondary
					icon.text: "skip_next"
					onClicked: MprisService.player.next()
				}
				IconButton {
					id: shuffleButton
					implicitWidth: 34
					implicitHeight: 34
					enabled: MprisService.player?.shuffleSupported ?? false
					theme: enabled && MprisService.player.shuffle ?
						StyledButton.Tertiary : StyledButton.TertiaryInactive

					onClicked: MprisService.player.shuffle = !MprisService.player.shuffle

					icon {
						font.weight: shuffleButton.enabled && MprisService.player.shuffle ?
							Config.font.weight.regular
							: Config.font.weight.light
						text: "shuffle"
					}
				}
			}
		}
	}
}
