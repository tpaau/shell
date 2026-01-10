pragma Singleton

import Quickshell

// Stores static paths for config and cache files.
Singleton {
	// Directory paths, ending with "Dir"
	readonly property string scriptsDir: Quickshell.shellDir + "/scripts"
	readonly property string cacheDir: Quickshell.shellDir + "/cache"
	readonly property string themesDir: Quickshell.shellDir + "/themes"
	readonly property string wallpapersDir: Quickshell.shellDir + "/assets/wallpapers"
	readonly property string shadersDir: Quickshell.shellDir + "/shaders/qsb"

	// File paths, ending with "File"
	readonly property string configFile: cacheDir + "/config.json"
	readonly property string cacheFile: cacheDir + "/cache.json"
	readonly property string wallpapersCacheFile: cacheDir + "/wallpapers.json"

	// Script paths, ending with "Script"
	readonly property string app2unitScript: scriptsDir + "/app2unit.sh"
	readonly property string termWrapScript: scriptsDir + "/wrap-term.sh"
}
