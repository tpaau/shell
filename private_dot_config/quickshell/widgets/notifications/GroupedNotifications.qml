pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.utils
import qs.services.notifications
import qs.services.config
import qs.services.config.theme

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

	property NotificationWidget firstNotification: null

	implicitWidth: Config.notifications.width
	implicitHeight: mainLayout.implicitHeight + Config.spacing.normal / 2

	function dismiss() {
		for (const notif of group.notifications) {
			Notifications.dismiss(notif)
		}
	}

	function delayedClose() {
		closeAnim.restart()
	}

	component NAnim: M3NumberAnim { data: root.regularAnimData }
	component FastAnim: M3NumberAnim { data: root.fastAnimData }
	component CAnim: M3ColorAnim { data: root.regularAnimData }

	ParallelAnimation {
		id: closeAnim
		onFinished: root.dismiss()

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
						root.delayedClose()
					} else {
						root.x = 0
					}
				}
			}
		}

		onClicked: {
			heightAnim.duration = heightAnim.data.duration
			root.group.expanded = !root.group.expanded
		}
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

			color: mainArea.containsPress && !mainArea.drag.active ?
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

						IconImage {
							anchors.centerIn: parent
							visible: root.group.icon !== ""
							implicitSize: parent.width - iconWrapper.radius
							source: root.group.icon
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

			Behavior on implicitHeight {NAnim {
				id: heightAnim
				duration: 0
			}}

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
					model: ScriptModel { values: [...root.group.notifications]  }

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
						Component.onCompleted: {
							if (index === 0) root.firstNotification = this
							const top = repeater.itemAt(index - 1)
							if (top) {
								siblingTop = top
								if (!siblingTop.siblingBottom) {
									siblingTop.siblingBottom = this
								}
							} else {
								siblingTop = null
							}
							const bottom = repeater.itemAt(index + 1)
							if (bottom) {
								siblingBottom = bottom
								if (!siblingBottom.siblingTop) {
									siblingBottom.siblingTop = this
								}
							} else {
								siblingBottom = null
							}
						}
					}
				}
			}
		}
	}
}
