pragma Singleton

import Quickshell
import qs.utils

Singleton {
	id: root

    // function getAppIcon(name: string, fallback: string): string {
    //     const icon = DesktopEntries.heuristicLookup(name)?.icon
    //     if (fallback !== "undefined")
    //         return Quickshell.iconPath(icon, fallback)
    //     return Quickshell.iconPath(icon)
    // }

	function getAppIcon(name: string, fallback: string): string {
		let entry = DesktopEntries.heuristicLookup(name)
		return entry ? Quickshell.iconPath(entry.icon, fallback) : ""
	}

	function pickIcon(value: real, icons: list<string>): string {
		return icons[Math.round((icons.length - 1) * Utils.clamp(value, 0.0, 1.0))]
	}
}
