pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import qs.utils
import qs.services
import qs.services.notifications

// This singleton manages notifications, their persistence and restoration.
//
// Ignored notifications are stored in the cache in a JSON file, but in the process of
// serialization some data is lost. Notably, notifications restored from JSON do not have
// actions, and do not support inline replies.
//
// Potentially incomplete notifications restored from JSON are tainted.
//
// On the other hand, fresh notifications are ones that have just been received by the
// notification server from a client.
//
// The Quickshell notification server supports reemitting notifications from the previous
// session (generation) in the present one. This server uses this to restore some tainted
// notifications to their fresh state.

Singleton {
	id: root

	readonly property alias notifications: server.notifications

	readonly property bool doNotDisturb: Cache.notifications.doNotDisturb
	function toggleDoNotDisturb() {
		Cache.notifications.doNotDisturb = !Cache.notifications.doNotDisturb
	}

	// Removes the notification from the stack.
	//
	// Return values:
	//   0 -> Notification removed successfully
	//   1 -> Notification was not found in the stack
	//   2 -> Notification value was invalid
	function dismissNotification(notification: NotificationData): int {
		if (!notification) return 2

		let id = server.notifications.indexOf(notification)
		if (id !== -1) {
			server.notifications.splice(id, 1)
			notification.original?.dismiss()
			dismissed(notification)
			return 0
		}

		return 1
	}

	// Emitted when a fresh notification is received from a client
	signal notification(notification: NotificationData)
	signal dismissed(notification: NotificationData)

	Component {
		id: notifData
		NotificationData {}
	}

	NotificationServer {
		id: server

		keepOnReload: true
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
				"id": notif.notificationId,
				"appName": notif.appName,
				"summary": notif.summary,
				"body": notif.body,
				"urgency": notif.urgency,
				"creationDate": notif.creationDate,
			}
		}

		function notificationsToJSON(): var {
			return JSON.stringify(notifications.map(
				(notif) => notifToJSON(notif)), null, 2
			)
		}

		function pushFresh(notif: NotificationData) {
			console.warn(`Pushing a fresh notification: ${notif}`)
			notifications.push(notif)
			root.notification(notif)
		}

		function restoreTainted(fresh: NotificationData) {
			console.info("Attempting to restore a tainted notification...")
			for (let notif of notifications) {
				if (notif.notificationId !== fresh.notificationId) {
					continue
				}
				if (notif.appName != fresh.appName) {
					console.error(`The ID matches, but the \`appName\` property does not! Fresh appName: "${fresh.appName}", tainted appName: "${notif.appName}"`)
					continue
				}
				if (notif.summary != fresh.summary) {
					console.error(`The ID matches, but the \`summary\` property does not! Fresh summary: "${fresh.summary}", tainted summary: "${notif.summary}"`)
					continue
				}
				if (notif.body != fresh.body) {
					console.error(`The ID matches, but the \`body\` property does not! Fresh body: "${fresh.body}", tainted body: "${notif.body}"`)
					continue
				}
				if (notif.urgency != fresh.urgency) {
					console.error(`The ID matches, but the \`urgency\` property does not! Fresh urgency: "${fresh.urgency}", tainted urgency: "${notif.urgency}"`)
					continue
				}
				console.warn("OK, matched the fresh notification")
				fresh.restored = true
				fresh.creationDate = notif.creationDate
				notifications[notifications.indexOf(notif)] = fresh
				return
			}
			console.warn(`Found no matching tainted ID for fresh notification with ID ${fresh.notificationId}, ignoring.`)
		}

		onNotification: (notification) => {
			console.warn(`Notification received: ${notification}`)
			notification.tracked = true
			const notif = notifData.createObject(root)
			notif.initFromNotification(notification)
			if (notification.lastGeneration) {
				restoreTainted(notif)
			} else {
				pushFresh(notif)
			}
		}
	}

	FileView {
		id: notifState
		path: Paths.notificationsCacheFile

		onLoaded: {
			const data = notifState.text()
			let notifs = JSON.parse(data).map((notif) => {
				return notifData.createObject(root, {
					"notificationId": notif.id,
					"appName": notif.appName,
					"summary": notif.summary,
					"body": notif.body,
					"urgency": notif.urgency,
					"creationDate": new Date(notif.creationDate),
					"tainted": true
				})
			})
			server.notifications = notifs
			console.warn("Tainted notifications loaded")
		}

		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) setText("{}")
		}
	}
}
