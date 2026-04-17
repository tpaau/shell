pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.utils
import qs.services.notifications
import qs.config
import qs.theme

// Notification group, eg. notifications from a particular app.
Item {
	id: root

	required property NotificationGroup group
	required property M3AnimData regularAnimData
	required property M3AnimData fastAnimData

	readonly property real contentFadeMult: 1.5
	readonly property int radiusLarge: Config.rounding.normal
	readonly property int radiusSmall: 6 // Don't EVER set this to an uneven number. It will cause pixelation.
	readonly property int padding: Config.spacing.small
	readonly property int iconSize: 40
	readonly property bool oneNotif: group.notifications.length === 1

	property NotificationWidget firstNotification: null

	implicitWidth: Config.notifications.width
	implicitHeight: mainLayout.implicitHeight

	component NAnim: M3NumberAnim { data: root.regularAnimData }
	component FastAnim: M3NumberAnim { data: root.fastAnimData }
	component CAnim: M3ColorAnim { data: root.regularAnimData }

	ParallelAnimation {
		id: closeAnim
		onFinished: Notifications.dismissBulk(group.notifications)

		FastAnim {
			target: root
			property: "x"
			from: root.x
			to: root.width * root.x / Math.abs(root.x)
		}
		FastAnim {
			target: root
			property: "height"
			from: root.height
			to: 0
		}
	}

	Behavior on x {
		NAnim {
			id: xRestoreAnim
			easing.bezierCurve: Anims.standard.spatial.fast.curve
		}
	}

	MouseArea {
		id: mainArea
		anchors.fill: parent
		preventStealing: true

		property real initialX
		property real prevX
		readonly property real dragDelta: Math.abs(prevX - root.x)

		drag {
			target: xRestoreAnim.running || closeAnim.running ? null : parent
			axis: Drag.XAxis

			onActiveChanged: {
				if (drag.active) {
					prevX = root.x
				} else {
					if (dragDelta > Config.notifications.dragDismissThreshold) {
						closeAnim.restart()
					} else {
						root.x = 0
					}
				}
			}
		}

		property bool childPressed: false
		onPressed: (mouse) => {
			if (root.oneNotif) {
				const point = notifColumn.mapFromItem(root, mouse.x, mouse.y)
				const notif = notifColumn.childAt(point.x, point.y)
				if (notif instanceof NotificationWidget) {
					childPressed = true
				}
			}
		}
		onClicked: (mouse) => {
			if (root.oneNotif) {
				const point = notifColumn.mapFromItem(root, mouse.x, mouse.y)
				const notif = notifColumn.childAt(point.x, point.y)
				if (notif instanceof NotificationWidget) {
					notif.expand()
					return
				}
			}
			root.group.expanded = !root.group.expanded
		}
		onReleased: childPressed = false
	}

	Column {
		id: mainLayout
		anchors {
			top: parent.top
			left: parent.left
		}
		spacing: root.radiusSmall / 2

		Rectangle {
			implicitWidth: parent.width
			implicitHeight: headerWrapper.implicitHeight

			color: mainArea.containsPress && !mainArea.drag.active && !mainArea.childPressed ?
				Theme.palette.surface_container : Theme.palette.surface_container_low
			radius: root.radiusLarge
			bottomRightRadius: root.firstNotification ?
				Utils.lerp(root.radiusSmall, root.radiusLarge, root.firstNotification.detachment) : root.radiusSmall
			bottomLeftRadius: bottomRightRadius

			Behavior on color { CAnim{} }

			Item {
				id: headerWrapper

				readonly property real spacing: Config.spacing.smaller

				implicitWidth: root.width
				implicitHeight: contentRow.implicitHeight + 2 * root.padding

				opacity: 1 - mainArea.dragDelta / root.width * root.contentFadeMult
				layer.enabled: true

				RowLayout {
					id: contentRow
					spacing: root.padding

					anchors {
						top: parent.top
						left: parent.left
						topMargin: root.padding
						leftMargin: root.padding
					}

					Rectangle {
						id: iconWrapper
						color: Theme.palette.surface_container_high
						implicitWidth: root.iconSize
						implicitHeight: root.iconSize
						radius: root.radiusLarge - root.padding

						Image {
							anchors.centerIn: parent
							visible: root.group.icon !== ""
							anchors {
								fill: parent
								margins: iconWrapper.radius
							}
							source: root.group.icon
							fillMode: Image.PreserveAspectFit
							sourceSize.width: width
							sourceSize.height: height
						}
						StyledIcon {
							anchors.centerIn: parent
							visible: !root.group.icon || root.group.icon == ""
							font.pixelSize: parent.width - iconWrapper.radius
							text: root.group.textIcon
						}
					}

					StyledText {
						id: groupName
						font.weight: Config.font.weight.heavy
						text: root.group.name
					}

					Item {
						implicitWidth: headerWrapper.width - iconWrapper.width
							- groupName.width - 3 * parent.spacing
							- 2 * headerWrapper.spacing
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

		Rectangle {
			id: notifColumnWrapper
			implicitWidth: notifColumn.implicitWidth
			implicitHeight: root.group.expanded ? notifColumn.implicitHeight
				: collapsedContentWrapper.implicitHeight
			color: "transparent"
			radius: root.radiusSmall
			bottomRightRadius: root.radiusLarge
			bottomLeftRadius: root.radiusLarge

			Rectangle {
				id: collapsedContentWrapper
				implicitWidth: Config.notifications.width
				implicitHeight: collapsedContent.implicitHeight
				color: mainArea.containsPress && !mainArea.drag.active ?
					Theme.palette.surface_container : Theme.palette.surface_container_low
				radius: root.radiusSmall
				bottomRightRadius: root.radiusLarge
				bottomLeftRadius: root.radiusLarge
				opacity: root.group.expanded ? 0 : 1

				Behavior on opacity { NAnim {} }
				Behavior on color { CAnim{} }

				Item {
					id: collapsedContent
					implicitWidth: Config.notifications.width
					implicitHeight: 2 * notifCountText.implicitHeight
					opacity: 1 - mainArea.dragDelta / root.width * root.contentFadeMult
					layer.enabled: true

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
				opacity: root.group.expanded ? 1 : 0
				layer.enabled: true
				enabled: root.group.expanded

				Behavior on opacity { NAnim {} }

				Repeater {
					id: repeater
					model: ScriptModel {
						values: [...root.group.notifications]
						onValuesChanged: {
							for (let i = 0; i < repeater.count; i++) {
								repeater.itemAt(i)?.resetConnections()
							}
						}
					}

					NotificationWidget {
						required property NotificationData modelData
						required property int index
						notificationData: modelData
						rightMargin: Math.max(mainArea.prevX + root.x, 0)
						leftMargin: Math.max(mainArea.prevX - root.x, 0)
						maxOpacity: headerWrapper.opacity
						radiusLarge: root.radiusLarge
						radiusSmall: root.radiusSmall
						regularAnimData: root.regularAnimData
						fastAnimData: root.fastAnimData
						padding: root.padding
						iconSize: root.iconSize
						showAppName: false
						isLone: root.oneNotif
						pressed: mainArea.childPressed && !mainArea.drag.active

						function resetConnections() {
							if (index === 0) root.firstNotification = this
							const top = repeater.itemAt(index - 1)
							if (top) {
								siblingTop = top
								siblingTop.siblingBottom = this
							} else {
								siblingTop = null
							}
							const bottom = repeater.itemAt(index + 1)
							if (bottom) {
								siblingBottom = bottom
								siblingBottom.siblingTop = this
							} else {
								siblingBottom = null
							}
						}

						Component.onCompleted: resetConnections()
						onModelDataChanged: resetConnections()
					}
				}
			}
		}
	}
}
