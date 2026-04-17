pragma Singleton

import Quickshell

// Stores static paths for config and cache files.
Singleton {
	// This should only be used in file paths, for the display name of the shell use `Utils.shellName`
	readonly property string shellName: "tpaau-shell"

	// Directory paths, ending with "Dir"
	// Static resources
	readonly property string scriptsDir: `${Quickshell.shellDir}/scripts`
	readonly property string themesDir: `${Quickshell.shellDir}/themes`
	readonly property string assetsDir: `${Quickshell.shellDir}/assets`
	readonly property string binProgramsDir: `${Quickshell.shellDir}/bin`
	readonly property string defaultWallpapersDir: `${assetsDir}/wallpapers`
	readonly property string fontsDir: `${assetsDir}/fonts`
	readonly property string materialSymbolsDir: `${fontsDir}/materialSymbols`

	// Dynamic resources
	readonly property string cacheDir: `${Quickshell.env("HOME")}/.cache/${shellName}`
	readonly property string configDir: `${Quickshell.env("HOME")}/.config/${shellName}`
	readonly property string dataDir: `${Quickshell.env("HOME")}/.local/share/${shellName}`
	readonly property string matugenThemesDir: `${cacheDir}/matugen`
	readonly property string shaderResourcesDir: `${assetsDir}/shaders/resources`
	readonly property string shadersDir: `${cacheDir}/shaders-qsb`

	// File paths, ending with "File"
	// Config
	readonly property string configFile: `${configDir}/config.json`
	readonly property string barConfigFile: `${configDir}/bar.json`
	readonly property string wallpapersConfigFile: `${configDir}/wallpapers.json`
	// Data
	readonly property string preferencesFile: `${dataDir}/preferences.json`
	readonly property string savedNotificationsFile: `${dataDir}/notifications.json`
	readonly property string favouriteAppsFile: `${dataDir}/fav-apps.json`
	// Cache
	readonly property string cacheFile: `${cacheDir}/cache.json`

	// Script paths, ending with "Script"
	readonly property string termWrapScript: `${scriptsDir}/wrap-term.sh`

	// Program paths, ending with "Program"
	readonly property string notificationHelperProgram: `${binProgramsDir}/notif-helper`

	// Image paths, ending with "Image"
	readonly property string profileImage: `${Quickshell.env("HOME")}.face`
}
