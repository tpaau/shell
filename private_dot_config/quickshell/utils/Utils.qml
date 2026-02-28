// Contains various functions dumped here to be reused.

pragma Singleton

import QtQuick
import Quickshell

Singleton {
	readonly property string shellName: "tpaau/dots"

	// Formats time for the `MediaControl` widget
	function formatHMS(seconds: int): string {
        if (seconds < 0)
            return "-1:-1"

        const hours = Math.floor(seconds / 3600)
        const mins = Math.floor((seconds % 3600) / 60)
        const secs = Math.floor(seconds % 60).toString().padStart(2, "0")

        if (hours > 0)
            return `${hours}:${mins.toString().padStart(2, "0")}:${secs}`
        return `${mins}:${secs}`
	}

	function clamp(num: real, min: real, max: real): real {
		return Math.min(Math.max(num, min), max)
	}

	function lerp(start: real, end: real, t: real): real {
		const tc = clamp(t, 0, 1)
		return start + (end - start) * tc
	}

	// Ensures that the given component is valid. Used in widgets that display
	// content from a `Component`.
	//
	// Return values:
	//   - 2: Given component value wasn't truthy
	//   - 3: Given component status was not `Component.Ready`
	function checkComponent(component: Component): int {
		if (!component) {
			console.warn("The given component was null/undefined!")
			return 2
		}
		else if (component.status !== Component.Ready) {
			console.warn("The given component was invalid or not ready!")
			return 3
		}
		return 0
	}

	function blendColor(a: color, b: color): color {
		return Qt.rgba((a.r + b.r) / 2, (a.g + b.g) / 2, (a.b + b.b) / 2, 1)
	}
}
