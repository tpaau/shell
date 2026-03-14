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
	readonly property string binProgramsDir: `${Quickshell.shellDir}/bin`
	readonly property string defaultWallpapersDir: `${Quickshell.shellDir}/assets/wallpapers`
	readonly property string iconPath: `${Quickshell.shellDir}/assets/materialIcons`

	// Dynamic resources
	readonly property string cacheDir: `${Quickshell.env("HOME")}/.cache/${shellName}`
	readonly property string configDir: `${Quickshell.env("HOME")}/.config/${shellName}`
	readonly property string matugenThemesDir: `${cacheDir}/matugen/`
	readonly property string shadersDir: `${cacheDir}/shaders-qsb`

	// File paths, ending with "File"
	readonly property string configFile: `${configDir}/config.json`
	readonly property string cacheFile: `${cacheDir}/cache.json`
	readonly property string notificationsCacheFile: `${cacheDir}/notifications-cache.json`
	readonly property string wallpapersConfigFile: `${configDir}/wallpapers.json`
	readonly property string favouriteAppsFile: `${cacheDir}/fav-apps.json`

	// Script paths, ending with "Script"
	readonly property string termWrapScript: `${scriptsDir}/wrap-term.sh`

	// Program paths, ending with "Program"
	readonly property string notificationHelperProgram: `${binProgramsDir}/notif-helper`

	// Image paths, ending with "Image"
	readonly property string profileImage: `${Quickshell.env("HOME")}.face`
}
