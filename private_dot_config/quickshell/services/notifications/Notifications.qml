pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import qs.services
import qs.services.notifications

Singleton {
	id: root

	readonly property alias temporalNotifications: persist.temporalNotifications
	readonly property alias ignoredNotifications: persist.ignoredNotifications

	readonly property bool doNotDisturb: Cache.notifications.doNotDisturb
	function toggleDoNotDisturb() {
		Cache.notifications.doNotDisturb = !Cache.notifications.doNotDisturb
	}

	// Removes the notification from the stack it belongs to. If the notification isn't
	// present in any of the stack, 1 is returned. If successful, 0 is returned.
	function dismissNotification(notification: NotificationData): int {
		if (!notification) return 2

		let id = temporalNotifications.indexOf(notification)
		if (id !== -1) {
			temporalNotifications.splice(id, 1)
			return 0
		}

		id = ignoredNotifications.indexOf(notification)
		if (id !== -1) {
			ignoredNotifications.splice(id, 1)
			return 0
		}

		return 1
	}

	Component {
		id: notifData
		NotificationData {
			server: root
		}
	}

	PersistentProperties {
		id: persist
		property list<NotificationData> temporalNotifications
		property list<NotificationData> ignoredNotifications
	}

	NotificationServer {
		// keepOnReload: false
		// imageSupported: true
		// actionsSupported: true
		// inlineReplySupported: true
		// bodyHyperlinksSupported: true
		// persistenceSupported: true
		// actionIconsSupported: true

		onNotification: (notification) => {
			notification.tracked = true
			let data = notifData.createObject(null)
			persist.temporalNotifications.push(data)
		}
	}
}
