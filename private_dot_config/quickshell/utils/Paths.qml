pragma Singleton

import Quickshell

Singleton {
	readonly property string scriptsDir: Quickshell.shellDir + "/scripts"
	readonly property string configFile: Quickshell.shellDir + "/config.json"
}
