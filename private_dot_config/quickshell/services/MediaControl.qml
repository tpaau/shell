pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
	id: root

	property alias player: persist.player

	PersistentProperties {
		id: persist
		property MprisPlayer player: null
	}

	Timer {
		running: !root.player
		interval: 1000
		repeat: true
		onTriggered: {
			if (Mpris.players.values.length > 0) {
				const playing = Mpris.players.values.find(p => p.isPlaying)
				if (playing) {
					root.player = playing
					return
				}
				root.player = Mpris.players.values[0]
			}
		}
	}

	FrameAnimation {
		running: root.player?.playbackState === MprisPlaybackState.Playing
		onTriggered: root.player?.positionChanged()
	}

	function getArtUrl(): string {
		if (root.player) {
			return root.player.trackArtUrl
		}
		return ""
	}

	IpcHandler {
		target: "mediaControl"

		function isAttached(): bool {
			return root.player
		}
		function getPlaybackState(): string {
			if (root.player) {
				switch (root.player.playbackState) {
				case MprisPlaybackState.Playing:
					return "playing"
				case MprisPlaybackState.Paused:
					return "paused"
				default:
					return "stopped"
				}
			}
			return "player not attached"
		}

		// Return values
		//   - 0: Success
		//   - 2: Player not attached
		//   - 3: Feature not supported
		function togglePlaying(): int {
			if (root.player) {
				if (root.player.canTogglePlaying) {
					root.player.togglePlaying()
					return 0
				} else {
					console.warn("Cannot toggle playing: feature not supported")
					return 3
				}
			} else {
				console.warn("Cannot toggle playing: player not attached")
				return 2
			}
		}
		function play(): int {
			if (root.player) {
				if (root.player.canPlay) {
					root.player.play()
					return 0
				} else {
					console.warn("Cannot play: feature not supported")
					return 3
				}
			} else {
				console.warn("Cannot play: player not attached")
				return 2
			}
		}
		function pause(): int {
			if (root.player) {
				if (root.player.canPause) {
					root.player.pause()
					return 0
				} else {
					console.warn("Cannot pause: feature not supported")
					return 3
				}
			} else {
				console.warn("Cannot pause: player not attached")
				return 2
			}
		}
		function previous(): int {
			if (root.player) {
				if (root.player.canGoPrevious) {
					root.player.previous()
					return 0
				} else if (root.player.canSeek && root.player.positionSupported) {
					root.player.position = 0
					return 0
				} else {
					console.warn("Cannot go previous: feature not supported")
					return 3
				}
			} else {
				console.warn("Cannot go previous: player not attached")
				return 2
			}
		}
		function next(): string {
			if (root.player) {
				if (root.player.canGoNext) {
					root.player.next()
					return 0
				} else {
					console.warn("Cannot go next: feature not supported")
					return 3
				}
			} else {
				console.warn("Cannot go next: player not attached")
				return 2
			}
		}
	}
}
