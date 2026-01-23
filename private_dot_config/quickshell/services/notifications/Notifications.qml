pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import qs.utils
import qs.services
import qs.services.notifications

Singleton {
	id: root

	readonly property alias notifications: server.notifications

	readonly property bool doNotDisturb: Cache.notifications.doNotDisturb
	function toggleDoNotDisturb() {
		Cache.notifications.doNotDisturb = !Cache.notifications.doNotDisturb
	}

	// Removes the notification from the stack it belongs to. If the notification isn't
	// present in any of the stack, 1 is returned. If successful, 0 is returned.
	function dismissNotification(notification: NotificationData): int {
		if (!notification) return 2

		let id = server.notifications.indexOf(notification)
		if (id !== -1) {
			server.notifications.splice(id, 1)
			return 0
		}

		return 1
	}

	signal notification(notification: NotificationData)

	Component {
		id: notifData
		NotificationData {}
	}

	NotificationServer {
		id: server

		keepOnReload: false
		// imageSupported: true
		actionsSupported: true
		// inlineReplySupported: true
		// bodyHyperlinksSupported: true
		persistenceSupported: true
		// actionIconsSupported: true

		property list<NotificationData> notifications: []
		onNotificationsChanged: notifState.setText(notificationsToJSON())

		function notifToJSON(notif: NotificationData): var {
			return {
				"appName": notif.appName,
				"summary": notif.summary,
				"body": notif.body,
				"urgency": notif.urgency,
				"creationDate": notif.creationDate
			}
		}

		function notificationsToJSON(): var {
			return JSON.stringify(notifications.map((notif) => notifToJSON(notif)), null, 2)
		}

		onNotification: (notification) => {
			notification.tracked = true
			const notif = notifData.createObject(root)
			notif.initFromNotification(notification)
			root.notification(notif)
			notifications.push(notif)
		}
	}

	FileView {
		id: notifState
		path: Paths.notificationsCacheFile

		onLoaded: {
			const data = notifState.text()
			let notifs = JSON.parse(data).map((notif) => {
				return notifData.createObject(root, {
					"appName": notif.appName,
					"summary": notif.summary,
					"body": notif.body,
					"urgency": notif.urgency,
					"creationDate": notif.creationDate
				})
			})
			server.notifications = notifs
		}

		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) setText("{}")
		}
	}
}
