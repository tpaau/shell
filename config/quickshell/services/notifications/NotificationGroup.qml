import QtQuick
import Quickshell
import qs.config
import qs.services.notifications

// Notifications grouped by the notification server into a group
QtObject {
	id: root

	required property list<NotificationData> notifications
	required property string name
	property bool expanded: true

	// The icon from the `appIcon` property of the `Notification` object
	readonly property string icon: {
		// No icon should be returned if the app is unknown (it'd look funny)
		if (name == Config.notifications.fallbackAppName) return ""
		const notif = notifications.find(n => n.icon != "")
		if (notif) {
			return Quickshell.iconPath(notif.icon, true)
		}
		return ""
	}

	// Material symbols set for specific app names
	readonly property string textIcon: {
		switch (name) {
			case "usbguard-notifier":
				return "shield_locked"
			case "niri":
				return "local_fire_department"
			case "secureblue":
				return "lock"
			case "kitty":
				return "terminal"
			case Config.notifications.fallbackAppName:
				return "help"
			default:
				return "notifications"
		}
	}
}
