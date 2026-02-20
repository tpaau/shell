pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.services
import qs.services.config

Rectangle {
	id: root

	property bool lockButtonEnabled: true

	readonly property int buttonSize: 40
	readonly property int margin: Config.rounding.normal / 2

	signal picked()

	radius: 2 * margin
	color: Theme.palette.surface

	MarginWrapperManager { margin: root.margin }

	RowLayout {
		id: layout
		spacing: root.margin
		anchors.centerIn: parent

		ActionButton {
			icon: ""
			onClicked: {
				root.picked()
				Session.logout()
			}
		}

		Loader {
			Layout.preferredWidth: root.buttonSize
			Layout.preferredHeight: root.buttonSize
			active: root.lockButtonEnabled
			visible: status === Loader.Ready
			asynchronous: true

			sourceComponent: ActionButton {
				icon: ""
				onClicked: {
					root.picked()
					Session.lock()
				}
			}
		}

		ActionButton {
			id: powerButton
			clip: false
			icon: ""
			iconObj.color: Theme.palette.textInverted
			theme: StyledButton.Theme.Bright

			onClicked: menu.open()

			StyledMenu {
				id: menu
				x: -width + powerButton.width + layout.spacing
				y: -height - 2 * root.margin
				transformOrigin: Popup.BottomRight

				StyledMenuItem {
					text: "Poweroff"
					icon.name: "power_settings_new"
					onTriggered: {
						root.picked()
						Session.poweroff()
					}
				}
				StyledMenuItem {
					text: "Reboot"
					icon.name: "restart_alt"
					onTriggered: {
						root.picked()
						Session.reboot()
					}
				}
				StyledMenuItem {
					text: "Suspend"
					icon.name: "bedtime"
					onTriggered: {
						root.picked()
						Session.suspend()
					}
				}
			}
		}
	}

	component ActionButton: StyledButton {
		implicitHeight: root.buttonSize
		implicitWidth: root.buttonSize
		rect.radius: Math.min(width, height) / 2

		property alias icon: styledIcon.text
		property alias iconObj: styledIcon

		StyledIcon {
			id: styledIcon
			anchors.centerIn: parent
			font.pixelSize: Config.icons.size.small
		}
	}
}
