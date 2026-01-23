import QtQuick
import qs.services.notifications

// Notifications grouped by the notification server into a group
QtObject {
	id: root

	required property string name
	required property list<NotificationData> notifications
}
