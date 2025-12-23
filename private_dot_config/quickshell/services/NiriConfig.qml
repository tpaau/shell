pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
	// This is just to bring this module into scope
	function init() {}

	FileView {
		readonly property string targetContents: `layout {
	gaps ${Config.wm.windowGaps}
}`

		path: Quickshell.env("HOME") + "/.config/niri/autogen/style.kdl"

		function tryWriteContents() {
			if (text() !== targetContents) {
				setText(targetContents)
			}
		}

		watchChanges: true
		Component.onCompleted: tryWriteContents()
		onFileChanged: tryWriteContents()
		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) tryWriteContents()
		}
	}
}
