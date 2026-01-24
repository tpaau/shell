import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.widgets.notifications
import qs.services.notifications

ColumnLayout {
	id: root

	spacing: list.spacing
	clip: true

	RowLayout {
		spacing: list.spacing

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

	ClippingRectangle {
		id: wrapper
		implicitWidth: list.implicitWidth
		implicitHeight: list.implicitHeight
		radius: Config.rounding.normal
		color: "transparent"

		StyledListView {
			id: list

			implicitWidth: Config.notifications.width
			implicitHeight: 300
			spacing: wrapper.radius / 2
			highlight: null
			clip: true

			model: Notifications.groups
			delegate: GroupedNotifications {
				required property NotificationGroup modelData
				group: modelData
			}
		}
	}
}
