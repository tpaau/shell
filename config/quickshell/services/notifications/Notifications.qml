pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import qs.cache
import qs.utils
import qs.services.notifications

// This singleton manages notifications, their persistence and restoration.
//
// Ignored notifications are stored in the data directory in a JSON file, but in the process of
// serialization some data is lost. Notably, notifications restored from JSON do not have
// actions, and do not support inline replies.
//
// Potentially incomplete notifications restored from JSON are tainted.
//
// On the other hand, fresh notifications are ones that have just been received by the
// notification server from a client.
//
// The Quickshell notification server supports restoring notifications from the previous
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
	// Do not use this inside an object instantiated with `groups` as the model as it may cause
	// race conditions.
	function dismiss(notification: NotificationData) {
		if (!notification) return
		if (notifications.indexOf(notification) < 0) return
		notification.original?.dismiss()
		dismissed(notification)
		notifications = notifications.filter(n => n.notificationId != notification.notificationId)
	}

	// Faster than dismissing a list of notifications individually but slower than dismissing the
	// same number of notifications via `dismissAll(...)`.
	//
	// NOTE: This one is also used to prevent race conditions where the changes in the notification
	// list changes the model for `NotificationList` interrupting dismiss.
	function dismissBulk(notifs: list<NotificationData>) {
		if (notifs.length < 1)  return
		for (const notif of notifs) {
			if (!notif) continue
			if (notifications.indexOf(notif) < 0) return
			notif.original?.dismiss()
			dismissed(notif)
		}
		notifications = notifications.filter(n => !notifs.find(d => d == n))
	}

	// Calling this is faster than dismissing all notifications individually
	function dismissAll() {
		for (const notif of server.notifications) {
			notif.original?.dismiss()
			dismissed(notif)
		}
		server.notifications = []
	}

	// Send a notification as the desktop shell
	//   - summary: The summary of the notification content
	//   - body: The body text of the notification
	//   - urgency: The urgency of the notification. Uses Quickshell.Services.Notifications.NotificationUrgency
	//   - module: The name of the shell module, eg. Session, Settings, etc.
	//   - actions: List of `ActionData` structs for the notification
	function sendNotif(
		summary: string,
		body: string,
		module = "",
		urgency: NotificationUrgency,
		actions: list<string>): int {
		const app = module !== "" ? `${Utils.shellName} - ${module}` : Utils.shellName
		let urgencyStr = "low"
		switch (urgency) {
			case NotificationUrgency.Low:
				urgencyStr = "low"
				break;
			case NotificationUrgency.Normal:
				urgencyStr = "normal"
				break;
			case NotificationUrgency.Critical:
				urgencyStr = "critical"
				break;
			default:
				console.warn(`Invalid urgency: ${urgency}, defaulting to "low"`)
				urgencyStr = "low"
				break;
		}
		let cmd = [
			Paths.notificationHelperProgram,
			"--summary", summary,
			"--body", body,
			"--app", app,
			"--urgency", urgencyStr,
		]
		if (actions && actions.length % 2 === 0) {
			for (const action of actions) {
				cmd.push(action)
			}
		}
		Quickshell.execDetached(cmd)
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
		persistenceSupported: true

		property list<NotificationData> notifications: []
		property list<NotificationGroup> groups: []

		onNotificationsChanged: {
			notifState.setText(notificationsToJSON())

			let newGroups = groups
			for (let group of newGroups) {
				group.notifications = []
			}
			for (const notif of notifications) {
				const group = newGroups.find(g => g.name == notif.appName)
				if (group) {
					group.notifications.push(notif)
				} else {
					newGroups.push(groupComp.createObject(root, {
						name: notif.appName,
						notifications: [notif]
					}))
				}
			}
			newGroups = newGroups.filter(g => g.notifications.length > 0)
			for (const group of newGroups) {
				group.notifications.sort((a, b) => b.creationDate - a.creationDate)
			}
			newGroups.sort((a, b) => b.notifications[0].creationDate - a.notifications[0].creationDate)
			groups = newGroups
		}

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
				"expanded": notif.expanded
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
		path: Paths.savedNotificationsFile
		watchChanges: true

		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) setText("{}")
		}
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
					"expanded": notif.expanded,
				})
			})
			server.notifications = notifs
			console.debug("Tainted notifications loaded")
		}
	}
}
