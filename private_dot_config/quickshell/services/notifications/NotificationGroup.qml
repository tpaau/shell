import QtQuick
import Quickshell
import qs.config
import qs.services.notifications

// Notifications grouped by the notification server into a group
QtObject {
	id: root

	required property string name
	required property list<NotificationData> notifications
	property bool expanded: false

	// The icon from the `appIcon` property of the `Notification` object
	readonly property string icon: {
		// No icon should be returned if the app is unknown (it'd look funny)
		if (name == Config.notifications.fallbackAppName) return ""
		for (const notif of notifications) {
			if (notif.icon && notif.icon != "") {
				return Quickshell.iconPath(notif.icon, true)
			}
		}
		return ""
	}

	// Material symbols set for specific app names
	readonly property string textIcon: {
		if (name == "usbguard-notifier") return "shield_locked"
		if (name == Config.notifications.fallbackAppName) return "help"
		return "terminal"
	}
}
