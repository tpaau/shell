// Stores static paths for config and cache files.

pragma Singleton

import Quickshell

Singleton {
	// Directory paths, ending with "Dir"
	readonly property string scriptsDir: Quickshell.shellDir + "/scripts"
	readonly property string cacheDir: Quickshell.shellDir + "/cache"
	readonly property string themesDir: Quickshell.shellDir + "/themes"
	readonly property string wallpapersDir: Quickshell.shellDir + "/assets/wallpapers"

	// File paths, ending with "File"
	readonly property string configFile: Quickshell.shellDir + "/config.json"
	readonly property string cacheFile: cacheDir + "/cache.json"
	readonly property string wallpapersCacheFile: cacheDir + "/wallpapers.json"
}
