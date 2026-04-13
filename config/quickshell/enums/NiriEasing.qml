pragma Singleton

import QtQuick
import Quickshell

// Enum representing easing type that can be used in
// both Qt animations and Niri animations.
Singleton {
	enum Easing {
		OutQuad,
		OutCubic,
		OutExpo,
		Linear
	}

	function toNiriName(easing: int): string {
		switch (easing) {
			case NiriEasing.OutQuad:
				return "ease-out-quad"
			case NiriEasing.OutCubic:
				return "ease-out-cubic"
			case NiriEasing.OutExpo:
				return "ease-out-expo"
			case NiriEasing.Linear:
				return "linear"
			default:
				console.warn(`Unknown easing id ${easing}, defaulting to ${NiriEasing.Linear}`)
				return "linear"
		}
	}

	function toAnimEasing(easing: int): int {
		switch (easing) {
			case NiriEasing.OutQuad:
				return Easing.OutQuad
			case NiriEasing.OutCubic:
				return Easing.OutCubic
			case NiriEasing.OutExpo:
				return Easing.OutExpo
			case NiriEasing.Linear:
				return Easing.Linear
			default:
				console.warn(`Unknown easing id ${easing}, defaulting to ${NiriEasing.Linear}`)
				return Easing.Linear
		}
	}
}
