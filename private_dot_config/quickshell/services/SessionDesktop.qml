pragma Singleton

import Quickshell

Singleton {
	readonly property int unknown: 0
	readonly property int niri: 1
	readonly property int sway: 2
	readonly property int hyprland: 3

	function toString(sessionDesktop: int): string {
		if (sessionDesktop == 1) return "Niri"
		if (sessionDesktop == 2) return "Sway"
		if (sessionDesktop == 3) return "Hyprland"
		return "Unknown desktop"
	}
}
