import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.widgets
import qs.config
import qs.utils
import qs.services
import qs.services.notifications

Column {
	id: root

	required property NotificationData notif
	required property int padding
	required property int desiredWidth
	required property int iconSize
	required property bool showAppName

	readonly property bool expandable: {
		if (bodyExpanded.implicitHeight > bodySingleLine.implicitHeight
			|| notif.icon !== "" || notif.image !== ""
			|| notif.original?.actions.length > 0)
			return true
		else return false
	}

	width: desiredWidth

	RowLayout {
		id: headLayout
		width: root.width
		spacing: root.padding

		Rectangle {
			id: iconWrapper
			color: Theme.palette.surfaceBright
			implicitWidth: root.iconSize
			implicitHeight: root.iconSize
			radius: Math.min(width, height) / 2
			Layout.alignment: Qt.AlignTop

			StyledIcon {
				anchors {
					fill: parent
					margins: root.padding
				}
				font.pixelSize: width
				text: {
					if (root.notif.urgency === NotificationUrgency.Critical) return "error"
					return "info"
				}
			}
		}

		Column {
			width: headLayout.width - iconWrapper.width - collapseIcon.width - 2 * headLayout.spacing
			spacing: root.padding / 2
			Layout.alignment: Qt.AlignTop

			RowLayout {
				id: summaryRow
				implicitWidth: parent.width
				implicitHeight: 20
				spacing: root.padding / 2

				StyledText {
					text: root.notif.summary
					Layout.preferredWidth: Math.min(implicitWidth, summaryRow.width - dateText.width - separator.width - 2 * summaryRow.spacing)
					font.pixelSize: Config.font.size.large
					color: Theme.palette.textIntense
					elide: Text.ElideRight
				}
				Rectangle {
					id: separator
					color: dateText.color
					implicitHeight: 6
					implicitWidth: 6
					radius: 3
					Layout.alignment: Qt.AlignCenter
				}
				StyledText {
					id: dateText
					text: Time.formatTimeElapsed(Math.floor((Time.date - root.notif.creationDate) / 60000))
					font.pixelSize: Config.font.size.small
					color: Theme.palette.textDim
					Layout.alignment: Qt.AlignCenter
				}
			}
			Item {
				id: bodyWrapper
				implicitWidth: parent.width
				implicitHeight: root.notif.expanded ? bodyExpanded.implicitHeight : bodySingleLine.implicitHeight

				StyledText {
					id: bodySingleLine
					visible: !root.notif.expanded
					text: root.notif.body
					width: parent.width
					font.pixelSize: Config.font.size.small
					color: Theme.palette.textDim
					elide: Text.ElideRight
				}
				StyledText {
					id: bodyExpanded
					visible: root.notif.expanded
					text: root.notif.body
					width: parent.width
					height: contentHeight
					font.pixelSize: Config.font.size.small
					color: Theme.palette.textDim
					wrapMode: Text.Wrap
				}
			}
		}

		CollapseIcon {
			id: collapseIcon
			visible: root.expandable
			expanded: root.notif.expanded
			Layout.alignment: Qt.AlignTop
		}
	}
}
