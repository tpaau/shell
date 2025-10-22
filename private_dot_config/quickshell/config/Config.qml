pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	readonly property string scriptsDir: Qt.resolvedUrl("../scripts/")
	readonly property string configFile: Qt.resolvedUrl("../config.json")

	readonly property Wallpaper wallpaper: Wallpaper {}

	readonly property Notifications notifications: Notifications {}
	readonly property Input input: Input {}
	readonly property Misc misc: Misc {}

	component Wallpaper: QtObject {
		readonly property string source: Qt.resolvedUrl("../assets/wallpapers/overlord-wallpaper2.png")
	}

	component Notifications: QtObject {
		readonly property int width: 400
		readonly property int maxWrapperHeight: 600
		readonly property int dragDismissThreshold: 100
		readonly property string fallbackAppName: "Unknown App"
		readonly property string fallbackSummary: "Notification"
		readonly property string fallbackBody: "No information provided."
	}

	component Input: QtObject {
		readonly property real scrollSensitivityMult: 0.5
	}

	component Misc: QtObject {
		readonly property int quickSettingsActivatiorWidth: 400
		readonly property int quickSettingsActivatiorHeight: 6
	}

	Component.onCompleted: {
		fileView.adapter.myStringProperty = "Hello!"
	}

	FileView {
		id: fileView
		path: root.configFile
		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()

		JsonAdapter {
			property string myStringProperty: "default value"
			property list<string> stringList: [ "default", "value" ]
			property JsonObject subObject: JsonObject {
				property string subObjectProperty: "default value"
			}
			property var inlineJson: { "a": "b" }
		}
	}
}
