pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.utils
import qs.config
import qs.services.notifications

// Notification group, eg. notifications from a particular app.
Item {
	id: root

	required property NotificationGroup group

	readonly property real contentFadeMult: 1.5
	readonly property real radiusLarge: Config.rounding.normal
	readonly property real radiusSmall: radiusLarge / 3

	property NotificationWidget firstNotification: null

	implicitWidth: Config.notifications.width
	implicitHeight: mainLayout.implicitHeight

	function dismiss() {
		for (const notif of group.notifications) {
			Notifications.dismiss(notif)
		}
	}

	component NAnim: M3NumberAnim { data: Anims.current.effects.regular }
	component CAnim: M3ColorAnim { data: Anims.current.effects.regular }

	Behavior on x {
		NAnim {
			id: xRestoreAnim
			easing.bezierCurve: Anims.standard.spatial.fast.curve
		}
	}

	MouseArea {
		id: mainArea
		anchors.fill: parent

		property real initialX
		property real prevX
		readonly property real dragDelta: Math.abs(prevX - root.x)

		drag {
			target: xRestoreAnim.running ? null : root
			axis: Drag.XAxis

			onActiveChanged: {
				if (drag.active) {
					prevX = root.x
				}
				else {
					if (dragDelta > Config.notifications.dragDismissThreshold) {
						root.dismiss()
					}
					else {
						root.x = 0
					}
				}
			}
		}

		onClicked: root.group.expanded = !root.group.expanded
	}

	Column {
		id: mainLayout
		spacing: root.radiusSmall / 2

		ClippingRectangle {
			id: headerWrapper

			anchors {
				left: parent.left
				leftMargin: root.x < 0 ? mainArea.dragDelta : 0
			}
			implicitWidth: parent.width - mainArea.dragDelta
			implicitHeight: headerRect.implicitHeight

			color: "red"
			// color: Theme.palette.surface
			radius: root.radiusLarge
			bottomRightRadius: root.firstNotification ?
				Utils.lerp(root.radiusSmall, root.radiusLarge, root.firstNotification.detachment) : root.radiusSmall
			bottomLeftRadius: bottomRightRadius

			Behavior on color { CAnim{} }

			Rectangle {
				id: headerRect

				readonly property real spacing: Config.spacing.smaller

				implicitWidth: root.width
				implicitHeight: contentRow.implicitHeight + 2 * spacing

				opacity: 1 - mainArea.dragDelta / root.width * root.contentFadeMult
				layer.enabled: true
				color: mainArea.containsPress ?
					Theme.palette.surfaceBright : Theme.palette.surface

				Behavior on color {
					M3ColorAnim { data: Anims.current.effects.fast }
				}

				RowLayout {
					id: contentRow
					spacing: root.radiusLarge / 2

					anchors {
						top: parent.top
						left: parent.left
						topMargin: parent.spacing
						leftMargin: parent.spacing
					}

					ClippingRectangle {
						id: iconWrapper
						color: Theme.palette.surfaceBright
						implicitWidth: 40
						implicitHeight: 40
						radius: root.radiusLarge - headerRect.spacing

						IconImage {
							anchors.centerIn: parent
							visible: root.group.icon !== ""
							implicitSize: parent.width - 2 * headerRect.spacing
							source: root.group.icon
						}
						StyledIcon {
							anchors.centerIn: parent
							visible: !root.group.icon || root.group.icon == ""
							font.pixelSize: parent.width - 3 * headerRect.spacing
							text: root.group.textIcon
						}
					}

					StyledText {
						id: groupName
						color: Theme.palette.textIntense
						font.weight: Config.font.weight.heavy
						text: root.group.name
					}

					Item {
						implicitWidth: headerRect.width - iconWrapper.width
							- groupName.width - 3 * parent.spacing
							- 2 * headerRect.spacing
						implicitHeight: collapseIcon.implicitHeight

						CollapseIcon {
							id: collapseIcon
							expanded: root.group.expanded
							anchors {
								right: parent.right
							}
						}
					}
				}
			}
		}

		ClippingRectangle {
			id: notifColumnWrapper
			implicitWidth: notifColumn.implicitWidth
			implicitHeight: root.group.expanded ? notifColumn.implicitHeight
				: collapsedContentWrapper.implicitHeight
			color: "transparent"
			radius: root.radiusSmall
			bottomRightRadius: root.radiusLarge
			bottomLeftRadius: root.radiusLarge

			Behavior on implicitHeight { NAnim {} }

			ClippingRectangle {
				id: collapsedContentWrapper
				anchors {
					left: parent.left
					leftMargin: root.x < 0 ? mainArea.dragDelta : 0
				}
				implicitWidth: Config.notifications.width - mainArea.dragDelta
				implicitHeight: collapsedContent.implicitHeight
				color: "red"
				opacity: root.group.expanded ? 0 : 1
				layer.enabled: true
				bottomRightRadius: root.radiusLarge
				bottomLeftRadius: root.radiusLarge

				Behavior on opacity { NAnim {} }

				Rectangle {
					id: collapsedContent
					implicitWidth: Config.notifications.width
					implicitHeight: 2 * notifCountText.implicitHeight
					opacity: 1 - mainArea.dragDelta / root.width * root.contentFadeMult
					layer.enabled: true
					color: Theme.palette.surface

					StyledText {
						id: notifCountText
						anchors.centerIn: parent
						text: root.group.notifications.length > 1 ?
							root.group.notifications.length + " notifications"
							: root.group.notifications.length + " notification"
					}
				}
			}

			Column {
				id: notifColumn
				spacing: root.radiusSmall / 2
				opacity: root.group.expanded ? 1 : 0
				layer.enabled: true
				enabled: root.group.expanded

				Behavior on opacity { NAnim {} }

				Repeater {
					id: repeater
					model: root.group.notifications

					NotificationWidget {
						required property NotificationData modelData
						required property int index
						notificationData: modelData
						rightMargin: Math.max(mainArea.prevX + root.x, 0)
						leftMargin: Math.max(mainArea.prevX - root.x, 0)
						maxOpacity: headerRect.opacity
						siblingTop: {
							if (index <= 1) return null
							else {
								const notif = notifColumn.children[notifColumn.children.indexOf(this) - 1]
								if (notif) return notif
								else return null
							}
						}
						siblingBottom: {
							if (index >= repeater.model.length - 1) return null
							else {
								const notif = notifColumn.children[notifColumn.children.indexOf(this) + 1]
								if (notif) return notif
								else return null
							}
						}
						Component.onCompleted: if (index === 0) root.firstNotification = this
					}
				}
			}
		}
	}
}
