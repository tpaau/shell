pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.services

Rectangle {
	id: root
	radius: 2 * margin
	color: Theme.palette.surface

	function closeDialogs() {
		contextMenu.close()
	}

	readonly property int buttonSize: 40
	readonly property int margin: Config.rounding.normal / 2

	MarginWrapperManager { margin: root.margin }

	RowLayout {
		id: layout
		spacing: root.margin
		anchors.centerIn: parent

		ActionButton {
			icon: ""
			onClicked: Session.logout()
		}

		ActionButton {
			icon: ""
			onClicked: Session.lock()
		}

		ActionButton {
			id: powerButton
			clip: false
			icon: ""
			iconObj.color: Theme.palette.textInverted
			disabledColor: Theme.palette.buttonBrightDisabled
			regularColor: Theme.palette.buttonBrightRegular
			hoveredColor: Theme.palette.buttonBrightHovered
			pressedColor: Theme.palette.buttonBrightPressed

			onPressed: contextMenu.toggleOpen()

			ContextMenu {
				id: contextMenu
				closeOnMouseExit: false
				x: -width + powerButton.width
				y: -height - 2 * root.margin
				entryWidth: 160
				entryHeight: 40
				smallerRadius: Config.rounding.small / 2
				largerRadius: Config.rounding.small

				onPicked: (index) => {
					switch(index) {
						case 0:
							Session.poweroff()
							break
						case 1:
							Session.reboot()
							break
						case 2:
							Session.suspend()
							break
					}
				}

				entries: [
					DropDownMenuEntry {
						name: "Poweroff"
						icon: ""
					},
					DropDownMenuEntry {
						name: "Reboot"
						icon: ""
					},
					DropDownMenuEntry {
						name: "Suspend"
						icon: ""
					}
				]
			}
		}
	}

	component ActionButton: StyledButton {
		id: button

		implicitHeight: root.buttonSize
		implicitWidth: root.buttonSize
		rect.radius: Math.min(width, height) / 2
		Layout.alignment: Qt.AlignRight

		property alias icon: styledIcon.text
		property alias iconObj: styledIcon

		StyledIcon {
			id: styledIcon
			anchors.centerIn: parent
			font.pixelSize: Config.icons.size.small
		}
	}
}
