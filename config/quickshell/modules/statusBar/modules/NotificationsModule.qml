import QtQuick
import qs.widgets.notifications
import qs.modules.statusBar.modules
import qs.services.notifications

ModuleGroup {
	id: root

	menuOpened: menu.opened
	onClicked: menu.open()

	BarIcon {
		text: {
			if (!Notifications.doNotDisturb && Notifications.notifications.length == 0) {
				return "notifications"
			} else {
				return Notifications.doNotDisturb ?
					"notifications_off" : "notifications_unread"
			}
		}
		color: root.contentColor
	}

	BarMenu {
		id: menu

		implicitWidth: contentItem.implicitWidth + 2 * padding
		implicitHeight: contentItem.implicitHeight + 2 * padding

		contentItem: NotificationList {}
	}
}
