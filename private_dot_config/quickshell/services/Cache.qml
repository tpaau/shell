pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	property alias notifications: adapter.notifications

	FileView {
		path: Paths.cacheFile
		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()

		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) writeAdapter()
		}

		JsonAdapter {
			id: adapter
			property JsonObject notifications: JsonObject {
				property bool doNotDisturb: false
			}
		}
	}
}
