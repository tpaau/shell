pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	// This should only be managed by the `Notifications` service
	property alias notifications: adapter.notifications
	property alias launcher: adapter.launcher

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
			property JsonObject launcher: JsonObject {
				property bool useGrid: false
			}
		}
	}
}
