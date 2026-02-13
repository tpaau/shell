pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
	id: root

	readonly property PwNode audioSink: Pipewire.defaultAudioSink
	onAudioSinkChanged: {
		if (audioSource) {
			audioSource.audio.volume = audioSource.audio.volume + 0.01
			audioSource.audio.volume = audioSource.audio.volume - 0.01
		}
	}
	PwObjectTracker {
		objects: [root.audioSink]
	}

	readonly property PwNode audioSource: Pipewire.defaultAudioSource
	PwObjectTracker {
		objects: [root.audioSource]
	}
}
