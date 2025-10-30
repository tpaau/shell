pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	readonly property alias animations: adapter.animations
	readonly property alias font: adapter.font
	readonly property alias icons: adapter.icons
	readonly property alias notifications: adapter.notifications
	readonly property alias quickSettings: adapter.quickSettings
	readonly property alias quality: adapter.quality
	readonly property alias rounding: adapter.rounding
	readonly property alias screenDecorations: adapter.screenDecorations
	readonly property alias sessionManagement: adapter.sessionManagement
	readonly property alias statusBar: adapter.statusBar
	readonly property alias shadows: adapter.shadows
	readonly property alias spacing: adapter.spacing
	readonly property alias wallpaper: adapter.wallpaper

	function alignmentFromStr(str: string): int {
		switch (str) {
			case "top":
				return Qt.AlignTop
			case "right":
				return Qt.AlignRight
			case "bottom":
				return Qt.AlignBottom
			case "left":
				return Qt.AlignLeft
		}
	}

	FileView {
		id: fileView
		path: Paths.configFile
		watchChanges: true
		onFileChanged: reload()
		onAdapterUpdated: writeAdapter()
		onAdapterChanged: writeAdapter()

		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) writeAdapter()
		}

		JsonAdapter {
			id: adapter

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
			property JsonObject font: JsonObject {
				property JsonObject family: JsonObject {
					property string regular: "Noto Sans"
					property string monospace: "Noto Sans Mono"
				}
				property JsonObject weight: JsonObject {
					property int heavy: 600
					property int regular: 500
					property int light: 300
				}
				property JsonObject size: JsonObject {
					property int smaller: 12
					property int small: 14
					property int normal: 16
					property int large: 18
					property int larger: 20
				}
			}
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
				property int buttonWidth: 250
				property int buttonHeight: 80
			}
			property JsonObject quality: JsonObject {
				property int layerSamples: 2
			}
			property JsonObject rounding: JsonObject {
				property int smaller: 8
				property int small: 12
				property int normal: 15
				property int large: 24

				property int window: large
				property int popout: large
			}
			property JsonObject screenDecorations: JsonObject {
				property JsonObject corners: JsonObject {
					property bool enabled: true
				}
				property JsonObject edges: JsonObject {
					property bool enabled: false
					property int size: 16
				}
			}
			property JsonObject sessionManagement: JsonObject {
				property int buttonSize: 128
			}
			property JsonObject statusBar: JsonObject {
				property bool enabled: true
				property int size: 54
				property int margin: 8
				property int moduleSize: size - 2 * margin

				// attached, semi-attached, detached
				property string style: "attached"
				property string alignment: "left"
			}
			property JsonObject shadows: JsonObject {
				property int blur: 4
				property int offset: 2
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
