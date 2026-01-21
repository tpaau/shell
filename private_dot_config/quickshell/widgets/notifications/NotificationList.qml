import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.widgets.notifications
import qs.services.notifications

ColumnLayout {
	id: root

	// Whether to use the temporal notification stack
	//   - true:  Uses the temporal stack
	//   - false: Uses the ignored stack
	required property bool useTemporal

	spacing: list.spacing
	clip: true

	RowLayout {
		spacing: list.spacing

		StyledButton {
			implicitWidth: list.implicitWidth
				- doNotDisturbButton.implicitWidth - parent.spacing
			implicitHeight: 40
			radius: height / 2

			regularColor: Theme.palette.surface
			hoveredColor: Theme.palette.buttonDarkRegular
			pressedColor: Theme.palette.buttonDarkHovered

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

			model: root.useTemporal ?
				Notifications.temporalNotifications : Notifications.ignoredNotifications
			delegate: NotificationWidget {
				required property NotificationData modelData
				notificationData: modelData
			}
		}
	}
}
