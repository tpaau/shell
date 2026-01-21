import QtQuick
import Quickshell.Services.Notifications
import qs.config
import qs.services

// Notification data used instead of the `Notification` type
Item {
	id: root

	property date creationDate
	property string summary: Config.notifications.fallbackSummary
	property string body: Config.notifications.fallbackBody
	property string appName: Config.notifications.fallbackAppName
	// The original notification used to create this one, if available.
	// This is not preserved through restarts.
	property int urgency: NotificationUrgency.Normal
	property int timeout: Config.notifications.defaultTimeout
	property Notification original

	// Can't be `Notifications` due to a circular dependency issue
	required property QtObject server

	// Emitted before being destroyed by the notification server
	signal dismissed()

	function initFromNotification(notification: Notification): int {
		creationDate = Time.date
		if (notification) {
			original = notification
			if (notification.summary && notification.summary != "")
				summary = notification.summary
			if (notification.body && notification.body != "")
				body = notification.body
			if (notification.appName && notification.appName != "")
				appName = notification.appName
			timeout = notification?.expireTimeout ?? Config.notifications.defaultTimeout
			urgency = notification?.urgency ?? NotificationUrgency.Normal
		} else {
			console.warn("Cannot create a notification data object from a nonexistent notification!")
			return 1
		}
	}

	function initFromJson() {
		console.warn("Deserialization from JSON is not yet supported!");
	}

	function toJson(): string {
		console.warn("Serialization to JSON is not yet supported!");
		return "{}"
	}

	function pauseExpireTimer() { expireTimer.stop() }
	function restartExpireTimer() { expireTimer.restart() }

	Timer {
		id: expireTimer
		interval: root.timeout
	}
}
