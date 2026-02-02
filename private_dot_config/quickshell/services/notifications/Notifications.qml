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
	readonly property alias groups: server.groups

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
	function dismiss(notification: NotificationData): int {
		if (!notification) return 2
		let notifs = []
		let found = false
		// No I will not use the `splice(...)` method, it freezes the UI for some reason.
		for (const notif of notifications) {
			if (notif !== notification) notifs.push(notif)
			else {
				notification.original?.dismiss()
				dismissed(notification)
			}
		}
		notifications = notifs
		if (found) return 0
		return 1
	}

	function dismissAll() {
		for (const notif of server.notifications) {
			if (server.notifications.indexOf(notif) !== -1) {
				notif.original?.dismiss()
				dismissed(notif)
			}
		}
		server.notifications = []
	}

	// Emitted when a fresh notification is received from a client, and do not
	// disturb is disabled.
	signal notification(notification: NotificationData)
	signal dismissed(notification: NotificationData)

	Component {
		id: notifData
		NotificationData {
			server: root
		}
	}

	Component {
		id: groupComp
		NotificationGroup {}
	}

	NotificationServer {
		id: server

		keepOnReload: true
		imageSupported: true
		actionsSupported: true
		// inlineReplySupported: true
		// bodyHyperlinksSupported: true
		persistenceSupported: true
		// actionIconsSupported: true

		property list<NotificationData> notifications: []
		onNotificationsChanged: {
			notifState.setText(notificationsToJSON())
			let newGroups = []
			for (const notif of notifications) {
				let found = false
				for (let group of newGroups) {
					if (group.name == notif.appName) {
						group.notifications.push(notif)
						found = true
					}
				}
				if (!found) {
					newGroups.push(groupComp.createObject(root, {
						name: notif.appName,
						notifications: [notif]
					}))
				}
			}
			groups = newGroups
		}
		property list<NotificationGroup> groups: []

		function notifToJSON(notif: NotificationData): var {
			return {
				"id": notif.notificationId,
				"appName": notif.appName,
				"summary": notif.summary,
				"body": notif.body,
				"icon": notif.icon,
				"image": notif.image,
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
			console.debug(`Pushing a fresh notification: ${notif}`)
			notifications.push(notif)
			if (!root.doNotDisturb) root.notification(notif)
		}

		function restoreTainted(fresh: NotificationData) {
			console.debug("Attempting to restore a tainted notification...")
			for (let notif of notifications) {
				if (notif.notificationId !== fresh.notificationId) {
					continue
				}
				console.debug("OK, matched the fresh notification")
				fresh.restored = true
				fresh.creationDate = notif.creationDate
				notifications[notifications.indexOf(notif)] = fresh
				return
			}
			console.debug(`Found no matching tainted ID for fresh notification with ID ${fresh.notificationId}, ignoring.`)
		}

		onNotification: (notification) => {
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
					"icon": notif.icon,
					"image": notif.image,
					"urgency": notif.urgency,
					"creationDate": new Date(notif.creationDate),
				})
			})
			server.notifications = notifs
			console.debug("Tainted notifications loaded")
		}

		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) setText("{}")
		}
	}
}
