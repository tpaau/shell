import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.config
import qs.widgets.notifications
import qs.services.notifications

ColumnLayout {
	id: root

	spacing: column.spacing
	clip: true

	component NAnim: M3NumberAnim { data: Anims.current.effects.regular }
	// component CAnim: M3ColorAnim { data: Anims.current.effects.regular }

	RowLayout {
		spacing: column.spacing

		StyledButton {
			id: notifSettingsButton

			implicitWidth: 50
			implicitHeight: 40
			radius: height / 2

			theme: StyledButton.Theme.Surface

			StyledIcon {
				anchors.centerIn: parent
				text: "notification_settings"
			}
		}
		StyledButton {
			implicitWidth: list.implicitWidth
				- notifSettingsButton.implicitWidth
				- doNotDisturbButton.implicitWidth
				- 2 * parent.spacing
			implicitHeight: 40
			radius: height / 2
			theme: StyledButton.Theme.Surface
			enabled: Notifications.notifications.length > 0

			onClicked: Notifications.dismissAll()

			StyledText {
				anchors.centerIn: parent
				text: "Clear all"
			}
		}
		StyledButton {
			id: doNotDisturbButton

			implicitWidth: 50
			implicitHeight: 40
			radius: height / 2

			theme: Notifications.doNotDisturb ?
				StyledButton.Theme.Bright : StyledButton.Theme.Surface

			onClicked: Notifications.toggleDoNotDisturb()

			StyledIcon {
				anchors.centerIn: parent
				text: Notifications.doNotDisturb ?
					"notifications_off" : "notifications"
				color: Notifications.doNotDisturb ?
					Theme.palette.textInverted : Theme.palette.text
			}
		}
	}

	StyledScrollView {
		id: list
		implicitHeight: 400
		implicitWidth: Config.notifications.width

		Column {
			id: column
			spacing: Config.spacing.normal / 2

			// move: Transition { NAnim { properties: "y" } }

			Repeater {
				model: ScriptModel { values: [...Notifications.groups] }
				delegate: GroupedNotifications {
					required property NotificationGroup modelData
					group: modelData
				}
			}
		}
	}
}
