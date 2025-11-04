import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.widgets
import qs.config
import qs.services

PanelWindow {
	id: root

	color: Theme.pallete.bg
	WlrLayershell.layer: WlrLayer.Background
	exclusionMode: ExclusionMode.Ignore
	exclusiveZone: 0

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}

	Image {
		anchors.centerIn: parent
		width: root.width
		height: root.height

		source: Config.wallpaper.source
		asynchronous: true
		cache: true
		sourceSize.width: root.width
		fillMode: Image.PreserveAspectCrop
	}

	MouseArea {
		id: desktopArea
		anchors.fill: parent
		acceptedButtons: Qt.AllButtons
		propagateComposedEvents: true
		onClicked: (mouse) => {
			if (!contextMenu.containsMouse) {
				contextMenu.close()
				mouse.accepted = false
				if (mouse.button == Qt.RightButton) {
					contextMenu.targetX = mouseX - contextMenu.width + 10
					contextMenu.targetY = mouseY - contextMenu.height + 10
					contextMenu.open()
				}
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

		disabledColor: Theme.pallete.bg.c1
		regularColor: Theme.pallete.bg.c2
		hoveredColor: Theme.pallete.bg.c3
		pressedColor: Theme.pallete.bg.c4

		onPicked: (index) => {
			if (index == 2) {
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
}
