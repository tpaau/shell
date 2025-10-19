pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
import qs.services

Rectangle {
	id: root
	radius: 2 * margin
	color: Theme.pallete.bg.c3
	implicitWidth: layout.width + 2 * margin
	implicitHeight: layout.height + 2 * margin

	function closeDialogs() {
		contextMenu.close()
	}

	readonly property int buttonSize: 40
	readonly property int margin: Appearance.rounding.normal / 2

	RowLayout {
		id: layout
		spacing: root.margin
		anchors.centerIn: parent

		ActionButton {
			icon: ""
		}

		ActionButton {
			id: powerButton
			clip: false
			icon: ""
			iconObj.color: enabled ? Theme.pallete.bg.c3 : Theme.pallete.bg.c7
			disabledColor: Theme.pallete.bg.c2
			regularColor: Theme.pallete.fg.c4
			hoveredColor: Theme.pallete.fg.c6
			pressedColor: Theme.pallete.fg.c8

			onPressed: contextMenu.toggleOpen()

			ContextMenu {
				id: contextMenu
				closeOnMouseExit: false
				x: -width + powerButton.width
				y: -height - 2 * root.margin
				entryWidth: 160
				entryHeight: 40
				smallerRadius: Appearance.rounding.small / 2
				largerRadius: Appearance.rounding.small

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
						case 3:
							Session.logout()
							break
						case 4:
							Session.lock()
							break
					}
				}

				Component {
					id: entry
					DropDownMenuEntry {}
				}

				entries: {
					entries: {
						let entries = []
						entries.push(entry.createObject(null, {
							index: 0,
							name: "Poweroff",
							icon: ""
						}))
						entries.push(entry.createObject(null, {
							index: 0,
							name: "Reboot",
							icon: ""
						}))
						entries.push(entry.createObject(null, {
							index: 0,
							name: "Suspend",
							icon: ""
						}))
						entries.push(entry.createObject(null, {
							index: 0,
							name: "Log out",
							icon: ""
						}))
						entries.push(entry.createObject(null, {
							index: 0,
							name: "Lock",
							icon: ""
						}))
						return entries
					}
				}
			}
		}
	}

	component ActionButton: StyledButton {
		id: button

		disabledColor: Theme.pallete.bg.c2
		regularColor: Theme.pallete.bg.c5
		hoveredColor: Theme.pallete.bg.c7
		pressedColor: Theme.pallete.bg.c8
		implicitHeight: root.buttonSize
		implicitWidth: root.buttonSize
		rect.radius: Math.min(width, height) / 2
		Layout.alignment: Qt.AlignRight

		property alias icon: styledIcon.text
		property alias iconObj: styledIcon

		StyledIcon {
			id: styledIcon
			anchors.centerIn: parent
			color: button.enabled ?
				Theme.pallete.fg.c4 : Theme.pallete.bg.c7
			font.pixelSize: Appearance.icons.size.small
		}
	}
}
