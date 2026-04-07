pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import qs.utils

Singleton {

	readonly property alias properties: adapter.properties
	readonly property bool isHorizontal: {
		if (adapter.properties.edge === Edges.Top
			|| adapter.properties.edge === Edges.Bottom) {
			return true
		}
		return false
	}
	readonly property alias modulesTopOrLeft: adapter.modulesTopOrLeft
	readonly property alias modulesCenter: adapter.modulesCenter
	readonly property alias modulesBottomOrRight: adapter.modulesBottomOrRight

	FileView {
		path: Paths.barConfigFile
		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()
		onAdapterChanged: writeAdapter()
		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) writeAdapter()
		}

		JsonAdapter {
			id: adapter

			property JsonObject properties: JsonObject {
				property int size: 58
				property int padding: 6
				property int spacing: 8
				property int edge: Edges.Left
				property int wrapperStyle: StatusBar.Style.AttachedRect
				property bool fill: true
				property bool enabled: true
				property int secondaryOffsets: 64
			}
			property list<string> modulesTopOrLeft: ["clock", "date", "window-title", "tray"]
			property list<string> modulesCenter: ["workspaces"]
			property list<string> modulesBottomOrRight: ["notifications", "caffeine", "quick-settings", "battery"]
		}
	}
}
