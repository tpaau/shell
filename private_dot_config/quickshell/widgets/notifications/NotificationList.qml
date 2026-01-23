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
			implicitWidth: list.implicitWidth
				- doNotDisturbButton.implicitWidth - parent.spacing
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

			model: Notifications.notifications
			delegate: NotificationWidget {
				required property NotificationData modelData
				notificationData: modelData
			}
		}
	}
}
