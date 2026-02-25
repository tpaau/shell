pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.widgets
import qs.services
import qs.services.notifications
import qs.services.config

Item {
	id: root

	required property NotificationData notif
	required property int padding
	required property int desiredWidth
	required property int iconSize
	required property bool showAppName

	readonly property bool expandable: true

	width: desiredWidth
	implicitHeight: rootRow.implicitHeight

	component Anim: M3NumberAnim { data: Anims.current.effects.fast }

	component NotificationActionButton: StyledButton {
		id: button
		required property NotificationAction action
		required property int padding
		required property int maxWidth
		Component.onCompleted: console.warn(`maxWidth: ${maxWidth}`)

		implicitWidth: Math.min(text.implicitWidth + 2 * padding, maxWidth)
		implicitHeight: text.implicitHeight + 2 * padding

		onClicked: action.invoke()

		StyledText {
			id: text
			anchors.centerIn: parent
			width: Math.min(contentWidth, button.maxWidth - 2 * button.padding)
			text: button.action.text
			elide: Text.ElideRight
		}
	}

	RowLayout {
		id: rootRow
		spacing: root.padding
		width: parent.width

		Item {
			id: iconColumnWrapper
			Layout.alignment: Qt.AlignTop
			implicitWidth: iconColumn.implicitWidth
			implicitHeight: iconColumn.implicitHeight

			Behavior on implicitHeight { Anim {} }

			ColumnLayout {
				id: iconColumn
				spacing: root.padding + bodyText.font.pixelSize
				implicitWidth: root.iconSize

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
						text: switch (root.notif.urgency) {
							case NotificationUrgency.Low:
								return "notifications_off"
							case NotificationUrgency.Normal:
								return "info"
							case NotificationUrgency.Critical:
								return "error"
						}
					}
				}

				Rectangle {
					id: imgWrapper
					visible: root.notif.expanded && imageOrIcon.status === Image.Ready
					color: Theme.palette.surfaceBright
					implicitWidth: root.iconSize
					implicitHeight: root.iconSize
					radius: Config.rounding.small
					Layout.alignment: Qt.AlignBottom

					Image {
						id: imageOrIcon
						asynchronous: true // May cause some notifications to not load
						mipmap: true
						fillMode: Image.PreserveAspectCrop
						sourceSize.width: width
						sourceSize.height: height
						anchors {
							fill: parent
							margins: root.padding
						}
						source: {
							if (root.notif.image !== "") return root.notif.image
							else if (root.notif.icon !== "") return root.notif.icon
							else return ""
						}
					}
				}
			}
		}
		ColumnLayout {
			id: mainColumn
			Layout.alignment: Qt.AlignTop
			implicitWidth: parent.width - iconColumnWrapper.implicitWidth - collapseIcon.implicitWidth - 2 * rootRow.spacing
			spacing: root.padding

			Item {
				id: headerLayoutWrapper
				implicitWidth: parent.width
				implicitHeight: headerLayout.implicitHeight

				RowLayout {
					id: headerLayout
					implicitWidth: parent.width
					spacing: Math.floor(root.padding / 2)

					StyledText {
						id: summary
						Layout.preferredWidth: Math.min(implicitWidth, headerLayoutWrapper.width - elapsed.implicitWidth - separator.implicitWidth - 2 * headerLayout.spacing)
						font.weight: Config.font.weight.heavy
						color: Theme.palette.textIntense
						text: root.notif.summary
						elide: Text.ElideRight
					}
					Rectangle {
						id: separator
						color: elapsed.color
						implicitWidth: 6
						implicitHeight: 6
						radius: Math.min(width, height) / 2
						Layout.alignment: Qt.AlignCenter
					}
					StyledText {
						id: elapsed
						color: Theme.palette.textDim
						font.pixelSize: Config.font.size.small
						text: Time.formatTimeElapsed(Math.floor((Time.date - root.notif.creationDate) / 60000))
						Layout.alignment: Qt.AlignCenter
					}
				}
			}
			Item {
				implicitWidth: parent.width
				implicitHeight: bodyText.contentHeight
				clip: true

				Behavior on implicitHeight { Anim {} }

				StyledText {
					id: bodyText
					width: parent.implicitWidth
					font.pixelSize: Config.font.size.small
					color: Theme.palette.textDim
					text: root.notif.body
					elide: root.notif.expanded ? Text.ElideNone : Text.ElideRight
					wrapMode: root.notif.expanded ? Text.Wrap : Text.NoWrap
				}
			}
			GridLayout {
				visible: root.notif.expanded
				implicitWidth: parent.width
				Layout.alignment: Qt.AlignCenter

				Repeater {
					model: root.notif.original.actions

					NotificationActionButton {
						required property NotificationAction modelData
						action: modelData
						padding: root.padding
						maxWidth: mainColumn.implicitWidth
					}
				}
			}
		}
		CollapseIcon {
			id: collapseIcon
			Layout.alignment: Qt.AlignTop
			expanded: root.notif.expanded
			visible: root.expandable
		}
	}
}
