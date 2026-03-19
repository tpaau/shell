pragma Singleton

import Quickshell

Singleton {
	id: root

	function getAppIcon(name: string): string {
		let entry = DesktopEntries.heuristicLookup(name)
		return entry ? Quickshell.iconPath(entry.icon) : ""
	}

	function pickIcon(value: real, icons: list<string>): string {
		return icons[Math.round((icons.length - 1) * value)]
	}
}
