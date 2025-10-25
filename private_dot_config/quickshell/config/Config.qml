pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	readonly property alias animations: adapter.animations
	readonly property alias icons: adapter.icons
	readonly property alias notifications: adapter.notifications
	readonly property alias quickSettings: adapter.quickSettings
	readonly property alias quality: adapter.quality
	readonly property alias rounding: adapter.rounding
	readonly property alias statusBar: adapter.statusBar
	readonly property alias shadows: adapter.shadows
	readonly property alias spacing: adapter.spacing
	readonly property alias wallpaper: adapter.wallpaper

	FileView {
		id: fileView
		path: Paths.configFile
		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()
		onLoadFailed: writeAdapter()

		JsonAdapter {
			id: adapter
			Component.onCompleted: dummyProperty = !dummyProperty

			property JsonObject animations: JsonObject {
				property JsonObject durations: JsonObject {
					property int shorter: 100
					property int shortish: 200
					property int normal: 300
					property int longish: 400
					property int longer: 500

					property int workspace: shortish
					property int button: shorter
					property int popout: shortish
					property int notificationExpand: shortish
				}
				property JsonObject easings: JsonObject {
					property int fade: Easing.InOutQuad
					property int fadeIn: Easing.InQuad
					property int fadeOut: Easing.OutQuad
					property int popout: Easing.OutCubic
					property int workspace: Easing.Linear
					property int button: Easing.Linear
					property int colorTransition: Easing.Linear
				}
			}
			property bool dummyProperty: false
			property JsonObject icons: JsonObject {
				property JsonObject size: JsonObject {
					property int smaller: 16
					property int small: 20
					property int regular: 24
					property int large: 28
					property int larger: 32
				}
				// Can be either  "Rounded", "Sharp", or "Outlined".
				property string style: "Rounded"
			}
			property JsonObject notifications: JsonObject {
				property int width: 400
				property int maxWrapperHeight: 600
				property int dragDismissThreshold: 100
				property string fallbackAppName: "Unknown App"
				property string fallbackSummary: "Notification"
				property string fallbackBody: "No information provided."
			}
			property JsonObject quickSettings: JsonObject {
				property int activatorWidth: 600
				property int activatorHeight: 6
			}
			property JsonObject quality: JsonObject {
				property int layerSamples: 4
			}
			property JsonObject rounding: JsonObject {
				property int smaller: 8
				property int small: 12
				property int normal: 15
				property int large: 24

				property int window: large
				property int popout: large
			}
			property JsonObject statusBar: JsonObject {
				property int size: 32
			}
			property JsonObject shadows: JsonObject {
				property int blur: 8
			}
			property JsonObject spacing: JsonObject {
				property int smaller: 4
				property int small: 8
				property int normal: 12
				property int large: 16
				property int larger: 20
			}
			property JsonObject wallpaper: JsonObject {
				property string source: Quickshell.shellDir
					+ "/assets/wallpapers/overlord-wallpaper2.png"
			}
		}
	}
}
