import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets
import qs.widgets
import qs.utils
import qs.services
import qs.config

Rectangle {
	id: root

	property int orientation: Qt.Vertical

	clip: true
	radius: Config.rounding.normal
	color: Theme.palette.surface

	MarginWrapperManager { margin: radius }

	GridLayout {
		id: mainLayout
		rowSpacing: root.radius
		columnSpacing: root.radius

		flow: root.orientation === Qt.Vertical ? GridLayout.TopToBottom
			: GridLayout.LeftToRight

		ClippingRectangle {
			implicitWidth: Math.min(parent.width, parent.height)
			implicitHeight: Math.min(parent.width, parent.height)
			radius: root.radius
			color: Theme.palette.surfaceBright

			StyledIcon {
				anchors.centerIn: parent
				font.pixelSize: Config.icons.size.larger
				visible: !coverArt.source || coverArt.source == "" ||
					(coverArt.status == Image.Ready && coverArt.opacity == 1)
				text: ""
			}

			Image {
				id: coverArt
				anchors.fill: parent

				onStatusChanged: {
					if (status === Image.Ready) {
						opacityAnim.enabled = true
						opacity = 1
					}
					else {
						opacityAnim.enabled = false
						opacity = 0
					}
				}
				asynchronous: true
				// sourceSize.width: width
				// sourceSize.height: height
				fillMode: Image.PreserveAspectCrop
				Layout.alignment: Qt.AlignTop
				source: MediaControl.getArtUrl()

				Behavior on opacity {
					id: opacityAnim
					M3NumberAnim { data: Anims.current.spatial.fast }
				}
			}
		}

		ColumnLayout {
			id: controlLayout
			spacing: mainLayout.rowSpacing
			Layout.alignment: Qt.AlignCenter

			Component {
				id: entry
				DropDownMenuEntry {
					name: "Unknown"
				}
			}

			DropDownMenu {
				id: playerPicker
				z: 2
				Layout.alignment: Qt.AlignCenter
				noEntriesText: "No players"
				textIcons: false
				fallbackIcon: ""

				Component.onCompleted: {
					const index = Mpris.players.values.indexOf(MediaControl.player)
					if (index || index === 0) {
						pick(entries[index])
					}
				}
				onPicked: (entry) => {
					if (Mpris.players.values.length > 0) {
						let player = Mpris.players.values[
							Math.min(entries.indexOf(entry), Mpris.players.values.length - 1)]
						if (player) {
							MediaControl.player = player
						}
					}
				}
				entries: {
					let players = []
					for (const player of Mpris.players.values) {
						players.push(entry.createObject(root, {
							name: player.identity,
							icon: Icons.getAppIcon(player.identity)
						}))
					}
					return players
				}

				Connections {
					target: MediaControl
					function onPlayerChanged() {
						let index = Mpris.players.values.indexOf(MediaControl.player)
						if (playerPicker.entries[index]) {
							playerPicker.selected = playerPicker.entries[index]
						}
					}
				}
			}

			ColumnLayout {
				StyledText {
					text: MediaControl.player?.trackTitle || "Unknown"
					font.pixelSize: Config.font.size.large
					font.weight: Config.font.weight.heavy
					Layout.preferredWidth: controlLayout.width
					Component.onCompleted: Layout.preferredHeight = height
					elide: Text.ElideRight
				}
				StyledText {
					text: MediaControl.player?.trackArtist || "Unknown"
					font.pixelSize: Config.font.size.small
					Layout.preferredWidth: controlLayout.width
					Component.onCompleted: Layout.preferredHeight = height
					elide: Text.ElideRight
				}
			}

			StyledSlider {
				id: seekSlider
				Layout.preferredWidth: parent.width
				Layout.preferredHeight: 13
				focusPolicy: Qt.NoFocus
				enabled: MediaControl.player?.canSeek ?? false

				property real delta: 0

				Binding {
					target: seekSlider
					property: "value"
					when: !seekSlider.pressed
					value: MediaControl.player ?
						Math.min(MediaControl.player.position
						/ MediaControl.player.length, 1)
						: 0
				}

				onPressedChanged: if (!pressed
					&& MediaControl.player
					&& MediaControl.player.canSeek
					&& MediaControl.player.positionSupported
					&& MediaControl.player.lengthSupported) {
					MediaControl.player.position = value * MediaControl.player.length
				}
			}

			RowLayout {
				Layout.preferredWidth: parent.width

				StyledText {
					text: MediaControl.player ?
					Utils.formatHMS(Math.min(
						seekSlider.value * MediaControl.player.length,
						MediaControl.player.length)) : "--:--"
					font.pixelSize: Config.font.size.smaller
					Layout.alignment: Qt.AlignLeft
					color: seekSlider.pressed ? Theme.palette.textIntense
						: Theme.palette.text
				}
				StyledText {
					text: MediaControl.player ?
						Utils.formatHMS(MediaControl.player.length) : "--:--"
					font.pixelSize: Config.font.size.smaller
					Layout.alignment: Qt.AlignRight
				}
			}

			RowLayout {
				id: buttonLayout
				spacing: root.radius
				Layout.alignment: Qt.AlignCenter

				readonly property int buttonSize: 40
				StyledButton {
					id: loopButton
					Layout.preferredWidth: 35
					Layout.preferredHeight: 35
					disabledColor: Theme.palette.surfaceBright
					regularColor: Theme.palette.surfaceBright
					hoveredColor: Theme.palette.buttonDisabled
					pressedColor: Theme.palette.buttonHovered
					enabled: MediaControl.player && MediaControl.player.loopSupported

					onClicked: {
						let player = MediaControl.player
						if (player.loopState === MprisLoopState.None) {
							player.loopState = MprisLoopState.Track
						}
						else if (player.loopState === MprisLoopState.Track) {
							player.loopState = MprisLoopState.Playlist
						}
						else {
							player.loopState = MprisLoopState.None
						}
					}

					StyledIcon {
						color: loopButton.enabled ?
							(MediaControl.player.loopState != MprisLoopState.None ?
								Theme.palette.text
								: Theme.palette.textDim) : Theme.palette.textDim
						font.weight: MediaControl.player
							? MediaControl.player.loopState != MprisLoopState.None
							? Config.font.weight.heavy
							: Config.font.weight.light
							: Config.font.weight.light
						anchors.centerIn: parent
						text: MediaControl.player
							&& MediaControl.player.loopState != MprisLoopState.Track ?
							"" : ""
					}
				}
				StyledButton {
					id: previousButton
					Layout.preferredWidth: 40
					Layout.preferredHeight: 40
					enabled: MediaControl.player && MediaControl.player.canGoPrevious

					onClicked: {
						if (MediaControl.player && MediaControl.player.canGoPrevious) {
							MediaControl.player.previous()
						}
					}

					StyledIcon {
						color: previousButton.enabled ?
							Theme.palette.text : Theme.palette.textDim
						anchors.centerIn: parent
						text: ""
					}
				}
				StyledButton {
					id: playPauseButton
					Layout.preferredWidth: 50
					Layout.preferredHeight: 50
					enabled: MediaControl.player
						&& (MediaControl.player.canPlay || MediaControl.player.canPause)
					rect.radius: MediaControl.player && MediaControl.player.isPlaying ?
						Math.min(width, height) / 3 : Math.min(width, height) / 2
					disabledColor: Theme.palette.buttonBrightDisabled
					regularColor: Theme.palette.buttonBrightRegular
					hoveredColor: Theme.palette.buttonBrightHovered
					pressedColor: Theme.palette.buttonBrightPressed

					onClicked: {
						if (MediaControl.player && MediaControl.player.canPause) {
							MediaControl.player.togglePlaying()
						}
					}

					StyledIcon {
						anchors.centerIn: parent
						font.pixelSize: Config.icons.size.large
						color: playPauseButton.enabled ?
							Theme.palette.textInverted : Theme.palette.text
						text: switch (MediaControl.player?.playbackState) {
							case MprisPlaybackState.Playing:
								return ""
							case MprisPlaybackState.Paused:
								return ""
							default:
								return ""
						}
					}
				}
				StyledButton {
					id: nextButton
					Layout.preferredWidth: 40
					Layout.preferredHeight: 40
					enabled: MediaControl.player && MediaControl.player.canGoNext
					onClicked: MediaControl.player.next()

					StyledIcon {
						color: previousButton.enabled ?
							Theme.palette.text : Theme.palette.textDim
						anchors.centerIn: parent
						text: ""
					}
				}
				StyledButton {
					id: shuffleButton
					Layout.preferredWidth: 35
					Layout.preferredHeight: 35
					disabledColor: Theme.palette.surfaceBright
					regularColor: Theme.palette.surfaceBright
					hoveredColor: Theme.palette.buttonDisabled
					pressedColor: Theme.palette.buttonHovered
					enabled: MediaControl.player && MediaControl.player.shuffleSupported

					onClicked: {
						MediaControl.player.shuffle = !MediaControl.player.shuffle
					}

					StyledIcon {
						color: shuffleButton ?
							(MediaControl.player?.shuffle ? Theme.palette.textIntense
							: Theme.palette.text) : Theme.palette.textDim
						font.weight: MediaControl.player
							? MediaControl.player.shuffle
							? Config.font.weight.regular :
							Config.font.weight.light : Config.font.weight.light
						anchors.centerIn: parent
						text: ""
					}
				}
			}
		}
	}
}
