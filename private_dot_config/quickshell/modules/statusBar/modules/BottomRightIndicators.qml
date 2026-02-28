pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.widgets.notifications
import qs.modules.statusBar.modules
import qs.utils
import qs.services
import qs.services.notifications
import qs.services.config
import qs.services.config.theme

GridLayout {
	id: root

	required property bool isHorizontal

	readonly property bool menuOpened: notificationsMenu.opened || caffeineMenu.opened || powerMenu.opened

	implicitWidth: isHorizontal ? 0 : Config.statusBar.size - 2 * Config.statusBar.padding
	implicitHeight: isHorizontal ? Config.statusBar.size - 2 * Config.statusBar.padding : 0

	columnSpacing: Config.statusBar.spacing / 2
	rowSpacing: Config.statusBar.spacing / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	ModuleGroup {
		id: indicators

		visible: isHorizontal ? width > 1 || connected : height > 1 || connected
		connected: notifications.enabled || Caffeine.running || privacy.active
		color: Theme.palette.primary

		topOrLeft: null
		bottomOrRight: resourceMonitors

		isHorizontal: root.isHorizontal

		BarButton {
			id: notifications
			visible: enabled
			onClicked: notificationsMenu.open()
			theme: StyledButton.Theme.Primary
			regularColor: Qt.alpha(Theme.palette.primary, 0)
			readonly property bool enabled: Notifications.doNotDisturb
				|| Notifications.notifications.length > 0

			icon {
				color: Theme.palette.surface
				text: Notifications.doNotDisturb ?
					"notifications_off" : "notifications_unread"
			}

			BarMenu {
				id: notificationsMenu
				implicitWidth: list.implicitWidth + 2 * padding
				implicitHeight: list.implicitHeight + 2 * padding

				NotificationList {
					id: list
				}
			}
		}
		BarButton {
			id: caffeine
			visible: Caffeine.running
			onClicked: caffeineMenu.open()
			theme: StyledButton.Theme.Primary
			regularColor: Qt.alpha(Theme.palette.primary, 0)

			icon {
				color: Theme.palette.surface
				text: ""
			}

			BarMenu {
				id: caffeineMenu
				implicitWidth: rect.implicitWidth + 2 * padding
				implicitHeight: rect.implicitHeight + 2 * padding

				Rectangle {
					id: rect
					implicitWidth: 100
					implicitHeight: 100
					color: "red"
				}
			}
		}
		Privacy {
			id: privacy
			isHorizontal: root.isHorizontal
		}
	}

	ModuleGroup {
		id: resourceMonitors

		topOrLeft: indicators
		bottomOrRight: null

		isHorizontal: root.isHorizontal

		StyledIcon {
			text: ""
			font.pixelSize: Config.icons.size.small
			Layout.preferredWidth: parent.width
		}

		StyledIcon {
			text: BTService.icon
			font.pixelSize: Config.icons.size.small
		}

		BarButton {
			readonly property real percentage: UPower.displayDevice?.percentage ?? 0
			property bool isHorizontal: root.isHorizontal
			readonly property list<string> iconsHorizontal: ["", "", "", "", "", "", "", ""]
			readonly property list<string> iconsVertical: ["", "", "", "", "", "", "", ""]
			readonly property list<string> iconsCurrent: isHorizontal ?
				iconsHorizontal : iconsVertical
			icon.fill: 0
			icon.text: Icons.pickIcon(percentage, iconsCurrent)
			onClicked: powerMenu.open()

			BarMenu {
				id: powerMenu
				implicitWidth: rect1.implicitWidth + 2 * padding
				implicitHeight: rect1.implicitHeight + 2 * padding

				Rectangle {
					id: rect1
					implicitWidth: 100
					implicitHeight: 100
					color: "red"
				}
			}
		}
	}
}
