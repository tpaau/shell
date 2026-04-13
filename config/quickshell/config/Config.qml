pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.enums
import qs.widgets
import qs.config
import qs.utils

Singleton {
	id: root

	readonly property alias animations: adapter.animations
	readonly property alias appearance: adapter.appearance
	readonly property alias appLauncher: adapter.appLauncher
	readonly property alias debug: adapter.debug
	readonly property alias font: adapter.font
	readonly property alias icons: adapter.icons
	readonly property alias input: adapter.input
	readonly property alias launcher: adapter.launcher
	readonly property alias notifications: adapter.notifications
	readonly property alias popouts: adapter.popouts
	readonly property alias preferences: adapter.preferences
	readonly property alias quickSettings: adapter.quickSettings
	readonly property alias rounding: adapter.rounding
	readonly property alias screenDecorations: adapter.screenDecorations
	readonly property alias sessionManagement: adapter.sessionManagement
	readonly property alias sessionLock: adapter.sessionLock
	readonly property alias spacing: adapter.spacing
	readonly property alias theme: adapter.theme
	readonly property alias toast: adapter.toast
	readonly property alias wallpaper: adapter.wallpaper
	readonly property alias wm: adapter.wm

	enum AuthenticationMethod {
		Password,
		PasswordOrFingerprint,
		PasswordAndFingerprint
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
			}
			property JsonObject debug: JsonObject {
				property bool processStderrForwarding: false
				property bool showFps: false
			}
			property JsonObject font: JsonObject {
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
				// Used for draggable objects, such as the quick settings panel
				property int maxDrag: 20
				property JsonObject mouse: JsonObject {
					property int pressAndHoldInterval: 300
				}
				property JsonObject keyboard: JsonObject {

				}
			}
			property JsonObject launcher: JsonObject {
				property string favIcon: "favorite" // I couldn't make my mind
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
			}
			property JsonObject preferences: JsonObject {
				property bool batteryWithPercentage: false
				property string terminalApp: "kitty"
			}
			property JsonObject rounding: JsonObject {
				property int smaller: 8
				property int small: 12
				property int normal: 15
				property int large: 24

				property int window: normal
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
			property JsonObject sessionLock: JsonObject {
				property int authMethod: Config.AuthenticationMethod.Password
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
				property bool forceDarkOnPowerSaver: false
				property real matugenThemeContrast: 0
				property real matugenThemeLightnessLight: 0
				property real matugenThemeLightnessDark: 0
				property string path: `${Paths.matugenThemesDir}/0.json`
			}
			property JsonObject toast: JsonObject {
				property bool pwSink: true
				property bool pwSource: true
				property bool brightness: true
				property int defaultTimeout: 1000
			}
			property JsonObject wallpaper: JsonObject {
				property bool parallax: false
				property bool rayMarchedParallax: false
				property bool disableRayMarchedParallaxOnPowersaver: true
				property real parallaxStrength: 0.1
				property int parallaxDelay: 600
				property string desktop: `${Paths.defaultWallpapersDir}/overlord-wallpaper.png`
				property string lockscreen: `${Paths.defaultWallpapersDir}/overlord-wallpaper.png`
				property string overview: `${Paths.defaultWallpapersDir}/overlord-wallpaper.png`
			}
			property JsonObject wm: JsonObject {
				property int windowGaps: adapter.spacing.normal
				property bool useHotCorners: true
				property int workspaceSwitchDuration: 250
				property int workspaceSwitchEasing: NiriEasing.OutExpo
				property int horizontalViewMovementDuration: 300
				property int horizontalViewMovementEasing: NiriEasing.OutExpo
				property int overviewOpenCloseDuration: 300
				property int overviewOpenCloseEasing: NiriEasing.OutExpo
			}
		}
	}
}
