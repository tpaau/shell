import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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

			theme: StyledButton.Theme.OnSurface

			StyledIcon {
				anchors.centerIn: parent
				text: "notification_settings"
			}
		}
		StyledButton {
			implicitWidth: scroll.implicitWidth
				- notifSettingsButton.implicitWidth
				- doNotDisturbButton.implicitWidth
				- 2 * parent.spacing
			implicitHeight: 40
			radius: height / 2
			theme: StyledButton.Theme.OnSurface
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
				StyledButton.Theme.Primary : StyledButton.Theme.OnSurface

			onClicked: Notifications.toggleDoNotDisturb()

			StyledIcon {
				anchors.centerIn: parent
				text: Notifications.doNotDisturb ?
					"notifications_off" : "notifications"
				color: Notifications.doNotDisturb ?
					Theme.palette.surface : Theme.palette.primary_fixed
			}
		}
	}

	ScrollView {
		id: scroll
		implicitHeight: 400
		implicitWidth: Config.notifications.width

		Column {
			// Doesn't work yet cuz the `Notifications` services does not reuse old groups
			move: Transition {
				M3NumberAnim {
					properties: "y"
					data: Anims.current.effects.fast
				}
			}

			Repeater {
				implicitWidth: Config.notifications.width
				model: ScriptModel { values: [...Notifications.groups] }

				delegate: GroupedNotifications {
					required property NotificationGroup modelData
					group: modelData
					regularAnimData: root.regularAnimData
					fastAnimData: root.fastAnimData
				}
			}
		}
	}
}
