pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.modules.toast.content
import qs.config
import qs.utils
import qs.services

Singleton {
	id: root

	readonly property PwNode audioSink: Pipewire.defaultAudioSink
	// Mitigation for a bug on my ThinkPad X9-14
	onAudioSinkChanged: {
		if (audioSource) {
			audioSource.audio.volume = audioSource.audio.volume + 0.01
			audioSource.audio.volume = audioSource.audio.volume - 0.01
		}
	}
	PwObjectTracker {
		objects: [root.audioSink]
	}

	readonly property string sinkIcon: {
		if (root.audioSink?.audio.volume > 0.0 && !root.audioSink?.audio.muted) {
			return Icons.pickIcon(
				root.audioSink?.audio.volume ?? 0.0,
				["volume_mute", "volume_down", "volume_up"]
			)
		}
		return "volume_off"
	}

	readonly property PwNode audioSource: Pipewire.defaultAudioSource
	PwObjectTracker {
		objects: [root.audioSource]
	}

	readonly property string sourceIcon: {
		if (root.audioSource?.audio.volume > 0.0 && !root.audioSource?.audio.muted) {
			return "mic"
		}
		return "mic_off"
	}

	Loader {
		active: Config.toast.pwSink
		asynchronous: true

		sourceComponent: Item {
			Component {
				id: sinkOsd
				ToastProgressIndicator {
					id: sinkIndicator
					icon: root.sinkIcon
					progress: {
						if (root.audioSink?.audio) {
							if (root.audioSink.audio.muted) return 0.0
							return root.audioSink.audio.volume
						}
						return 0.0
					}

					Connections {
						target: root.audioSink?.audio

						function onVolumeChanged() {
							sinkIndicator.restartTimer()
						}
						function onMutedChanged() {
							sinkIndicator.restartTimer()
						}
					}
				}
			}

			Connections {
				target: root.audioSink?.audio

				function onVolumeChanged() {
					Ipc.toast?.openIfNotBusy(sinkOsd)
				}
				function onMutedChanged() {
					Ipc.toast?.openIfNotBusy(sinkOsd)
				}
			}
		}
	}

	Loader {
		active: Config.toast.pwSource
		asynchronous: true

		sourceComponent: Item {
			Component {
				id: sourceOsd
				ToastProgressIndicator {
					id: sourceIndicator
					icon: root.sourceIcon
					progress: {
						if (root.audioSource?.audio) {
							if (root.audioSource.audio.muted) return 0.0
							return root.audioSource.audio.volume
						}
						return 0.0
					}

					Connections {
						target: root.audioSource?.audio

						function onVolumeChanged() {
							sourceIndicator.restartTimer()
						}
						function onMutedChanged() {
							sourceIndicator.restartTimer()
						}
					}
				}
			}

			Connections {
				target: root.audioSource?.audio

				function onVolumeChanged() {
					Ipc.toast?.openIfNotBusy(sourceOsd)
				}
				function onMutedChanged() {
					Ipc.toast?.openIfNotBusy(sourceOsd)
				}
			}
		}
	}
}
