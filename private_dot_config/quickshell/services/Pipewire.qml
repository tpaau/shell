pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
	id: root

	readonly property PwNode audioSink: Pipewire.defaultAudioSink
	PwObjectTracker {
		objects: [root.audioSink]
	}

	readonly property PwNode audioSource: Pipewire.defaultAudioSource
	PwObjectTracker {
		objects: [root.audioSource]
	}
}
