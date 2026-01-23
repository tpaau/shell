import QtQuick
import Quickshell.Services.Notifications
import qs.config
import qs.services

// Notification data used instead of the `Notification` type
QtObject {
	id: root

	// Must be an item due to a circular dependency issue
	required property QtObject server

	// Properties that are serialized to JSON
	property int notificationId: -1
	property string appName: Config.notifications.fallbackAppName
	property string summary: Config.notifications.fallbackSummary
	property string body: Config.notifications.fallbackBody
	property int urgency: NotificationUrgency.Normal
	property date creationDate
	property int timeout: Config.notifications.defaultTimeout

	// Properties that are not preserved in JSON
	property list<NotificationAction> actions: []

	// The original notification used to create this object.
	//
	// If null, the notification is tainted, otherwise it's either restored or fresh.
	property Notification original: null
	onOriginalChanged: if (!original) {
		server.dismiss(this)
	}

	// Whether the notification has been matched and replaced by a fresh one.
	property bool restored: false

	// Emitted before being destroyed by the notification server
	signal dismissed()

	function initFromNotification(notification: Notification): int {
		creationDate = Time.date
		if (notification) {
			notificationId = notification.id
			if (notification.summary && notification.summary != "")
				summary = notification.summary
			if (notification.body && notification.body != "")
				body = notification.body
			if (notification.appName && notification.appName != "")
				appName = notification.appName
			timeout = notification?.expireTimeout ?? Config.notifications.defaultTimeout
			urgency = notification?.urgency ?? NotificationUrgency.Normal
			actions = notification?.actions ?? []
		} else {
			console.warn("Cannot create a notification data object from a nonexistent notification!")
			return 1
		}
	}
}
