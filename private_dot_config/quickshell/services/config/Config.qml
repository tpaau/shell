pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.widgets
import qs.modules.statusBar
import qs.utils

Singleton {
	id: root

	readonly property alias animations: adapter.animations
	readonly property alias appearance: adapter.appearance
	readonly property alias appLauncher: adapter.appLauncher
	readonly property alias border: adapter.border
	readonly property alias debug: adapter.debug
	readonly property alias font: adapter.font
	readonly property alias goofy: adapter.goofy
	readonly property alias icons: adapter.icons
	readonly property alias input: adapter.input
	readonly property alias notifications: adapter.notifications
	readonly property alias popouts: adapter.popouts
	readonly property alias preferences: adapter.preferences
	readonly property alias quickSettings: adapter.quickSettings
	readonly property alias quality: adapter.quality
	readonly property alias rounding: adapter.rounding
	readonly property alias scpReferences: adapter.scpReferences
	readonly property alias screenDecorations: adapter.screenDecorations
	readonly property alias sessionManagement: adapter.sessionManagement
	readonly property alias sessionLock: adapter.sessionLock
	readonly property alias statusBar: adapter.statusBar
	readonly property alias shadows: adapter.shadows
	readonly property alias spacing: adapter.spacing
	readonly property alias theme: adapter.theme
	readonly property alias wallpaper: adapter.wallpaper
	readonly property alias wm: adapter.wm

	enum AuthenticationMethod {
		Password,
		PasswordAndFingerprint,
		PasswordOrFingerprint
	}

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
			property JsonObject appearance: JsonObject {
				property JsonObject blur: JsonObject {
					property bool enabled: true
					property real strength: 0.75
				}
			}
			property JsonObject appLauncher: JsonObject {
				property int entryHeight: 70
				property int gridCellSize: 120
				property int horizontalCellCount: 5
				property int entriesShown: 6
			}
			property JsonObject border: JsonObject {
				property int width: 2
			}
			property JsonObject debug: JsonObject {
				property bool processStderrForwarding: false
				property bool showFps: false
			}
			property JsonObject font: JsonObject {
				property JsonObject family: JsonObject {
					property string regular: "Noto Sans"
					property string mono: "Noto Sans Mono"
				}
				property JsonObject weight: JsonObject {
					property int heavy: 650
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
				property int maxDrag: 20
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
				property int defaultTimeout: 16
				property string fallbackAppName: "Unknown App"
				property string fallbackSummary: "Notification"
				property string fallbackBody: "No information provided."
			}
			property JsonObject popouts: JsonObject {
				property int style: PopoutShape.Style.Attached
			}
			property JsonObject quickSettings: JsonObject {
				property int buttonWidth: 250
				property int buttonHeight: 80
				property bool closeOnPressedOutside: true
				property int dragDismissThreshold: 100
				property JsonObject activator: JsonObject {
					property bool visible: true
					property int width: 400
					property int height: 6
				}
			}
			property JsonObject preferences: JsonObject {
				property bool batteryWithPercentage: false
				property string terminalApp: "kitty"
			}
			property JsonObject quality: JsonObject {
				property int layerSamples: 2
			}
			property JsonObject rounding: JsonObject {
				property int smaller: 8
				property int small: 12
				property int normal: 15
				property int large: 24

				property int screenCorner: large
				property int window: normal
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
			property JsonObject sessionLock: JsonObject {
				property int authMethod: Config.AuthenticationMethod.Password
			}
			property JsonObject statusBar: JsonObject {
				property int size: 56
				property int padding: 6
				property int spacing: 8
				property int edge: Edges.Left
				property int wrapperStyle: StatusBar.Style.AttachedRect
				property bool enabled: true
				property int secondaryOffsets: 64
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
				property bool useMatugen: true
				property bool dark: true
				property real matugenThemeContrast: 0
				property real matugenThemeLightnessLight: 0
				property real matugenThemeLightnessDark: 0
				property string name: "matugen0"
			}
			property JsonObject wallpaper: JsonObject {
				property bool parallax: false
				property real parallaxStrength: 0.1
				property int parallaxDelay: 600
			}
			property JsonObject wm: JsonObject {
				property int windowGaps: 12
			}
		}
	}
}
