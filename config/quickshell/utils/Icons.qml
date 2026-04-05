pragma Singleton

import Quickshell
import qs.utils

Singleton {
	id: root

	function getAppIcon(name: string, fallback = "image-missing"): string {
		let entry = DesktopEntries.heuristicLookup(name)
		return entry ? Quickshell.iconPath(entry.icon, fallback) : fallback
	}

	function pickIcon(value: real, icons: list<string>): string {
		return icons[Math.round((icons.length - 1) * Utils.clamp(value, 0.0, 1.0))]
	}
}
