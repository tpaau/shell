pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.widgets
import qs.utils
import qs.services
import qs.services.config
import qs.services.config.theme

PanelWindow {
	id: root

	color: Theme.palette.background
	WlrLayershell.layer: WlrLayer.Background
	exclusionMode: ExclusionMode.Ignore
	exclusiveZone: 0

	property string desktopWallpaperDepthmap: ""

	function toDepthFilename(filename: string): string {
		return filename.replace(/(\.[^.\/\\]+)?$/, (ext) => ext ? `_depth${ext}` : `_depth`)
	}

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}

	component CustomMenuItem: StyledMenuItem {
		implicitHeight: 40
		highlightedColor: Theme.palette.surface_container
	}

	component CustomMenu: StyledMenu {
		implicitWidth: 280
		color: Theme.palette.surface
		transformOrigin: Popup.TopLeft
		delegate: CustomMenuItem {}
	}

	Process {
		command: ["ls", root.toDepthFilename(Config.wallpaper.desktop)]
		running: true
		onCommandChanged: running = true
		onExited: (exitCode) => {
			if (exitCode == 0) root.desktopWallpaperDepthmap = root.toDepthFilename(Config.wallpaper.desktop)
			else console.debug(`No wallpaper depth map found (${root.toDepthFilename(Config.wallpaper.desktop)})`)
		}
	}

	CustomMenu {
		id: menu

		CustomMenuItem {
			text: "Settings"
			icon.name: "settings"
			enabled: false
		}
		CustomMenuItem {
			text: "Wallpaper"
			icon.name: "image"
			enabled: false
		}
		CustomMenuItem {
			text: "Refresh"
			icon.name: ""
			enabled: false
		}
		CustomMenu {
			title: "Session"
			icon.name: "account_circle"

			CustomMenuItem {
				text: "Lock"
				icon.name: "lock"
				onTriggered: Session.lock()
			}
			CustomMenuItem {
				text: "Logout"
				icon.name: "logout"
				onTriggered: Session.logout()
			}
		}
		CustomMenu {
			title: "Power"
			icon.name: "power_settings_new"

			CustomMenuItem {
				text: "Poweroff"
				icon.name: "power_settings_new"
				onTriggered: Session.poweroff()
			}
			CustomMenuItem {
				text: "Reboot"
				icon.name: "restart_alt"
				onTriggered: Session.reboot()
			}
			CustomMenuItem {
				text: "Suspend"
				icon.name: "bedtime"
				onTriggered: Session.suspend()
			}
		}
	}

	MouseArea {
		id: desktopArea
		anchors.fill: parent
		acceptedButtons: Qt.AllButtons
		propagateComposedEvents: true
		hoverEnabled: true

		property real offsetX: 0
		property real offsetY: 0

		onClicked: (mouse) => {
			if (mouse.button === Qt.RightButton) {
				menu.x = mouseX
				menu.y = mouseY
				menu.open()
			}
		}

		onPositionChanged: {
			offsetX = (mouseX / width - 0.5) * 2.0
			offsetY = (mouseY / height - 0.5) * 2.0
		}

		Behavior on offsetX {
			NumberAnimation {
				duration: Config.wallpaper.parallaxDelay
				easing.type: Easing.OutQuart
			}
		}
		Behavior on offsetY {
			NumberAnimation {
				duration: Config.wallpaper.parallaxDelay
				easing.type: Easing.OutQuart
			}
		}
	}

	Image {
		id: staticWallpaper
		source: Config.wallpaper.desktop
		anchors.centerIn: parent
		asynchronous: true
		cache: true
		sourceSize.width: Config.wallpaper.parallax ?
			Math.ceil(parent.width * (1.0 + Config.wallpaper.parallaxStrength))
			: parent.width
		sourceSize.height: Config.wallpaper.parallax ?
			Math.ceil(parent.height * (1.0 + Config.wallpaper.parallaxStrength))
			: parent.height
		smooth: false // No need, the image is scaled to the native resolution
		fillMode: Image.PreserveAspectCrop

		Loader {
			asynchronous: true
			anchors.fill: parent
			active: root.desktopWallpaperDepthmap && Config.wallpaper.parallax

			sourceComponent: ShaderEffect {
				visible: desktopArea.offsetX != 0 && desktopArea.offsetY != 0
				anchors.fill: parent

				property variant source: Image {
					anchors.fill: parent
					source: Config.wallpaper.desktop
					asynchronous: true
					sourceSize.width: width
					sourceSize.height: height
					smooth: false // No need, the image is scaled to the native resolution
					fillMode: Image.PreserveAspectCrop
				}

				property variant depthMap: Image {
					anchors.fill: parent
					source: root.desktopWallpaperDepthmap
					asynchronous: true
					sourceSize.width: width
					sourceSize.height: height
					smooth: false // No need, the image is scaled to the native resolution
					fillMode: Image.PreserveAspectCrop
				}

				readonly property real offsetX: desktopArea.offsetX
				readonly property real offsetY: desktopArea.offsetY
				readonly property real parallaxStrength: Config.wallpaper.parallaxStrength
				readonly property real aspectRatio: source.sourceSize.width / source.sourceSize.height

				// DepthFlow shaders with ray marching
				vertexShader: Paths.shadersDir + "/parallax.vert.qsb"
				fragmentShader: Paths.shadersDir + "/parallax.frag.qsb"
			}
		}
	}
}
