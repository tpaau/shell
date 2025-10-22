pragma Singleton

import Quickshell

Singleton {
	function getAppIcon(name: string): string {
		let entry = DesktopEntries.heuristicLookup(name)
		return entry ? Quickshell.iconPath(entry.icon) : ""
	}

	function pickIcon(value: real, icons: list<string>): string {
		let i = Math.round(icons.length * value)
		i = Math.min(icons.length - 1, Math.max(0, i))
		return icons[i]
	}
}
