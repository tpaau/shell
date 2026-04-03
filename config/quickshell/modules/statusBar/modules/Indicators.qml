import qs.theme
import qs.widgets
import qs.widgets.notifications
import qs.modules.statusBar
import qs.services
import qs.services.notifications

ModuleGroup {
	id: root

	visible: BarConfig.isHorizontal ?
		width > 1 || connected
		: height > 1 || connected
	connected: notifications.enabled || caffeine.enabled || privacy.active
	color: Theme.palette.primary
	topOrLeft: null

	menuOpened: notificationsMenu.opened
		|| caffeineMenu.opened

	BarButton {
		id: notifications
		visible: enabled
		onClicked: notificationsMenu.open()
		theme: StyledButton.Theme.Primary
		readonly property bool enabled: Notifications.doNotDisturb
			|| Notifications.notifications.length > 0
			|| notificationsMenu.visible

		icon {
			color: Theme.palette.surface
			text: {
				if (!Notifications.doNotDisturb && Notifications.notifications.length == 0) {
					return "notifications"
				} else {
					return Notifications.doNotDisturb ?
						"notifications_off" : "notifications_unread"
				}
			}
		}

		BarMenu {
			id: notificationsMenu
			implicitWidth: list.implicitWidth + 2 * padding
			implicitHeight: list.implicitHeight + 2 * padding

			contentItem: NotificationList {
				id: list
			}
		}
	}
	BarButton {
		id: caffeine
		visible: enabled
		enabled: Caffeine.running || caffeineMenu.visible
		onClicked: caffeineMenu.open()
		theme: StyledButton.Theme.Primary

		icon {
			color: Theme.palette.surface
			text: ""
		}

		BarMenu {
			id: caffeineMenu
			implicitWidth:  caffeineMenuContent.implicitWidth + 2 * padding
			implicitHeight: caffeineMenuContent.implicitHeight + 2 * padding

			contentItem: CaffeineMenu {
				id: caffeineMenuContent
			}
		}
	}
	Privacy {
		id: privacy
		isHorizontal: BarConfig.isHorizontal
	}
}
