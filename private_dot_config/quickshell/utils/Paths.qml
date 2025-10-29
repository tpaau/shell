pragma Singleton

import Quickshell

Singleton {
	readonly property string scriptsDir: Quickshell.shellDir + "/scripts"
	readonly property string configFile: Quickshell.shellDir + "/config.json"
	readonly property string cacheFile: Quickshell.shellDir + "/cache/cache.json"
}
