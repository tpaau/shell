pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	readonly property alias animations: adapter.animations
	readonly property alias appLauncher: adapter.appLauncher
	readonly property alias debug: adapter.debug
	readonly property alias font: adapter.font
	readonly property alias goofy: adapter.goofy
	readonly property alias icons: adapter.icons
	readonly property alias input: adapter.input
	readonly property alias notifications: adapter.notifications
	readonly property alias popouts: adapter.popouts
	readonly property alias quickSettings: adapter.quickSettings
	readonly property alias quality: adapter.quality
	readonly property alias rounding: adapter.rounding
	readonly property alias scpReferences: adapter.scpReferences
	readonly property alias screenDecorations: adapter.screenDecorations
	readonly property alias sessionManagement: adapter.sessionManagement
	readonly property alias statusBar: adapter.statusBar
	readonly property alias shadows: adapter.shadows
	readonly property alias spacing: adapter.spacing
	readonly property alias theme: adapter.theme
	readonly property alias wallpaper: adapter.wallpaper
	readonly property alias widgets: adapter.widgets
	readonly property alias wm: adapter.wm

	readonly property int popoutAttached: 0
	readonly property int popoutDetached: 1

	FileView {
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
				property real speedMultiplier: 1.0
				property bool expressive: true
			}
			property JsonObject appLauncher: JsonObject {
				property int entryWidth: 500
				property int entryHeight: 80
				property int entriesShown: 5
			}
			property JsonObject debug: JsonObject {
				property bool processStderrForwarding: false
				property bool countFps: false
			}
			property JsonObject font: JsonObject {
				property JsonObject family: JsonObject {
					property string regular: "Noto Sans"
					property string mono: "Noto Sans Mono"
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
			property JsonObject goofy: JsonObject {
				property bool activateLinuxEnabled: false
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
			property JsonObject input: JsonObject {
				property JsonObject mouse: JsonObject {
					property int pressAndHoldInterval: 300
				}
				property JsonObject keyboard: JsonObject {

				}
			}
			property JsonObject notifications: JsonObject {
				property int width: 450
				property int maxWrapperHeight: 600
				property int dragDismissThreshold: 100
				property string fallbackAppName: "Unknown App"
				property string fallbackSummary: "Notification"
				property string fallbackBody: "No information provided."
			}
			property JsonObject popouts: JsonObject {
				property int style: root.popoutAttached
			}
			property JsonObject quickSettings: JsonObject {
				property int buttonWidth: 250
				property int buttonHeight: 80
				property JsonObject activator: JsonObject {
					property bool visible: true
					property int width: 400
					property int height: 6
				}
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
			property JsonObject scpReferences: JsonObject {
				property bool enabled: false
				property bool lockscreenCognitohazardEnabled: false
			}
			property JsonObject screenDecorations: JsonObject {
				property JsonObject corners: JsonObject {
					property bool enabled: true
				}
				property JsonObject edges: JsonObject {
					property bool enabled: false
					property int size: 16
				}
				// Currently does nothing
				property bool shadowsEnabled: true
			}
			property JsonObject sessionManagement: JsonObject {
				property int buttonSize: 128
			}
			property JsonObject statusBar: JsonObject {
				property bool enabled: true
				property int size: 54
				property int margin: 8
				property int moduleSize: size - 2 * margin
				property int dialogSize: 128
				property int popupOffset: (size - moduleSize) / 2
				property int edge: Edges.Left
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
			property JsonObject theme: JsonObject {
				property string name: "black"
			}
			property JsonObject wallpaper: JsonObject {
				property bool parallax: false
				property real parallaxStrength: 0.1
				property int parallaxDelay: 600
			}
			property JsonObject widgets: JsonObject {
			}
			property JsonObject wm: JsonObject {
				property int windowGaps: 12
			}
		}
	}
}
