import QtQuick
import qs.config
import qs.services.notifications

Rectangle {
	id: root

	required property NotificationData data

	implicitWidth: Config.notifications.width
	implicitHeight: 50

	color: Theme.palette.background
	radius: Config.rounding.normal
}
