pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.utils
import qs.widgets
import qs.config

PanelWindow {
	id: root

	color: Theme.palette.background
	WlrLayershell.layer: WlrLayer.Background
	exclusionMode: ExclusionMode.Ignore
	exclusiveZone: 0

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}

	MouseArea {
		id: desktopArea
		anchors.fill: parent
		acceptedButtons: Qt.AllButtons
		propagateComposedEvents: true
		hoverEnabled: true

		onClicked: (mouse) => {
			if (!contextMenu.containsMouse) {
				contextMenu.close()
				mouse.accepted = false
				if (mouse.button === Qt.RightButton) {
					contextMenu.targetX = mouseX - contextMenu.width + 10
					contextMenu.targetY = mouseY - contextMenu.height + 10
					contextMenu.open()
				}
			}
		}

		property real offsetX: 0
		property real offsetY: 0

		onPositionChanged: {
			offsetX = (mouseX / width - 0.5) * 2.0
			offsetY = (mouseY / height - 0.5) * 2.0
		}

		onExited: {
			offsetX = 0
			offsetY = 0
		}

		Behavior on offsetX {
			NumberAnimation {
				duration: 800
				easing.type: Easing.OutQuart
			}
		}
		Behavior on offsetY {
			NumberAnimation {
				duration: 800
				easing.type: Easing.OutQuart
			}
		}
	}

	ContextMenu {
		id: contextMenu

		property real targetX: 0
		property real targetY: 0

		onOpened: {
			x = targetX
			y = targetY
		}

		onPicked: (index) => {
			if (index === 2) {
				Quickshell.reload(true)
			}
		}

		entries: [
			DropDownMenuEntry {
				name: "Settings"
				icon: ""
			},
			DropDownMenuEntry {
				name: "Wallpaper"
				icon: ""
			},
			DropDownMenuEntry {
				name: "Refresh"
				icon: ""
			}
		]
	}

	Image {
		source: Theme.desktopWallpaper
		anchors.fill: parent
		asynchronous: true
		cache: true
		sourceSize.width: parent.width
		fillMode: Image.PreserveAspectCrop
	}

	Loader {
		asynchronous: true
		anchors.fill: parent
		active: Theme.desktopWallpaperDepthmap && Config.wallpaper.parallax

		sourceComponent: ShaderEffect {
			visible: desktopArea.offsetX != 0 && desktopArea.offsetY != 0
			anchors.fill: parent

			property variant source: Image {
				anchors.fill: parent
				source: Theme.desktopWallpaper
				smooth: true
				fillMode: Image.PreserveAspectCrop
			}

			property variant depthMap: Image {
				anchors.fill: parent
				source: Theme.desktopWallpaperDepthmap
				smooth: true
				fillMode: Image.PreserveAspectCrop
			}

			property real offsetX: desktopArea.offsetX
			property real offsetY: desktopArea.offsetY
			property real parallaxStrength: 0.10
			property real aspectRatio: source.sourceSize.width / source.sourceSize.height

			// DepthFlow shaders with ray marching
			vertexShader: Paths.shadersDir + "/parallax.vert.qsb"
			fragmentShader: Paths.shadersDir + "/parallax.frag.qsb"
		}
	}
}
