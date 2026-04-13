import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.widgets
import qs.config
import qs.widgets.notifications
import qs.services.notifications

ColumnLayout {
	id: root

	spacing: Config.spacing.normal / 2
	layer.enabled: true
	clip: true

	readonly property M3AnimData regularAnimData: Anims.current.effects.regular
	readonly property M3AnimData fastAnimData: Anims.current.effects.fast
	// readonly property M3AnimData regularAnimData: Anims.current.effects.slow
	// readonly property M3AnimData fastAnimData: Anims.current.effects.slow

	component NAnim: M3NumberAnim { data: root.fastAnimData }

	RowLayout {
		spacing: root.spacing

		StyledButton {
			id: notifSettingsButton

			implicitWidth: 50
			implicitHeight: 40
			radius: height / 2

			theme: StyledButton.Theme.OnSurfaceContainer

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
			theme: StyledButton.Theme.OnSurfaceContainer
			enabled: Notifications.groups.length > 0
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
				StyledButton.Theme.Primary : StyledButton.Theme.OnSurfaceContainer

			onClicked: Notifications.toggleDoNotDisturb()

			StyledIcon {
				anchors.centerIn: parent
				text: Notifications.doNotDisturb ?
					"notifications_off" : "notifications"
				theme: Notifications.doNotDisturb ? StyledIcon.Theme.Inverse : StyledIcon.Theme.Regular
			}
		}
	}

	ScrollView {
		id: scroll
		implicitHeight: 400
		implicitWidth: Config.notifications.width

		Column {
			spacing: Config.spacing.normal / 2
			move: Transition {
				M3NumberAnim {
					properties: "y"
					data: root.fastAnimData
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
