import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
import qs.widgets.notifications
import qs.services.notifications

ColumnLayout {
	id: root

	spacing: column.spacing
	clip: true

	RowLayout {
		spacing: column.spacing

		StyledButton {
			id: notifSettingsButton

			implicitWidth: 50
			implicitHeight: 40
			radius: height / 2

			theme: ButtonTheme.surface

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
			theme: ButtonTheme.surface
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
				ButtonTheme.bright : ButtonTheme.surface

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

			Repeater {
				model: Notifications.groups
				delegate: GroupedNotifications {
					required property NotificationGroup modelData
					group: modelData
				}
			}
		}
	}
}
