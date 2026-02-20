import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.services.config
import qs.widgets.notifications
import qs.services.notifications

ColumnLayout {
	id: root

	spacing: Config.spacing.normal / 2
	clip: true

	readonly property M3AnimData regularAnimData: Anims.current.effects.regular
	readonly property M3AnimData fastAnimData: Anims.current.effects.fast

	component NAnim: M3NumberAnim { data: root.fastAnimData }

	RowLayout {
		spacing: root.spacing

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

	Item {
		implicitWidth: list.implicitWidth
		implicitHeight: list.implicitHeight
		clip: true

		ListView {
			id: list
			implicitHeight: 400
			implicitWidth: Config.notifications.width
			model: ScriptModel { values: [...Notifications.groups] }

			// remove: Transition {
			// 	NAnim {
			// 		property: "opacity"
			// 		to: 0
			// 	}
			// 	NAnim {
			// 		property: "x"
			// 		to: 100
			// 	}
			// 	NAnim {
			// 		property: "implicitHeight"
			// 		to: 0
			// 	}
			// }

			// add: Transition {
			// 	NumberAnimation {
			// 		property: "opacity"
			// 		from: 0
			// 		to: 1
			// 	}
			// }

			delegate: GroupedNotifications {
				required property NotificationGroup modelData
				group: modelData
				regularAnimData: root.regularAnimData
				fastAnimData: root.fastAnimData
			}
		}
	}
}
