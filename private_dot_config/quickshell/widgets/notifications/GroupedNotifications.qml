pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
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

	component NAnim: M3NumberAnim {
		data: Anims.current.effects.regular
	}
	component CAnim: M3ColorAnim {
		data: Anims.current.effects.regular
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
			target: xRestoreAnim.running ? null : parent
			axis: Drag.XAxis

			onActiveChanged: {
				if (drag.active) {
					prevX = root.x
				} else {
					if (dragDelta > Config.notifications.dragDismissThreshold) {
						root.dismiss()
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
		spacing: root.radiusSmall / 2

		Rectangle {
			id: headerWrapper

			implicitWidth: parent.width
			implicitHeight: headerRect.implicitHeight

			color: mainArea.containsPress && !mainArea.drag.active ? Theme.palette.surfaceBright :
																	 Theme.palette.surface

			radius: root.radiusLarge
			bottomRightRadius: root.firstNotification ? Utils.lerp(root.radiusSmall, root.radiusLarge,
																   root.firstNotification.detachment) : root.radiusSmall
			bottomLeftRadius: bottomRightRadius

			Behavior on color {
				CAnim {}
			}

			Item {
				id: headerRect

				readonly property real spacing: Config.spacing.smaller

				implicitWidth: root.width
				implicitHeight: contentRow.implicitHeight + 2 * spacing

				opacity: 1 - mainArea.dragDelta / root.width * root.contentFadeMult
				layer.enabled: true

				RowLayout {
					id: contentRow
					spacing: root.radiusLarge / 2

					anchors {
						top: parent.top
						left: parent.left
						topMargin: parent.spacing
						leftMargin: parent.spacing
					}

					Rectangle {
						id: iconWrapper
						color: Theme.palette.surfaceBright
						implicitWidth: 40
						implicitHeight: 40
						radius: root.radiusLarge - headerRect.spacing

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
						color: Theme.palette.textIntense
						font.weight: Config.font.weight.heavy
						text: root.group.name
					}

					Item {
						implicitWidth: headerRect.width - iconWrapper.width - groupName.width - 3 * parent.spacing
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

		Rectangle {
			id: notifColumnWrapper
			implicitWidth: notifColumn.implicitWidth
			implicitHeight: root.group.expanded ? notifColumn.implicitHeight :
												  collapsedContentWrapper.implicitHeight
			color: "transparent"
			radius: root.radiusSmall
			bottomRightRadius: root.radiusLarge
			bottomLeftRadius: root.radiusLarge

			Behavior on implicitHeight {
				NAnim {
					id: heightAnim
					duration: 0
				}
			}

			Rectangle {
				id: collapsedContentWrapper
				implicitWidth: Config.notifications.width
				implicitHeight: collapsedContent.implicitHeight
				color: mainArea.containsPress && !mainArea.drag.active ? Theme.palette.surfaceBright :
																		 Theme.palette.surface
				bottomRightRadius: root.radiusLarge
				bottomLeftRadius: root.radiusLarge
				opacity: root.group.expanded ? 0 : 1

				Behavior on opacity {
					NAnim {}
				}
				Behavior on color {
					CAnim {}
				}

				Item {
					id: collapsedContent
					implicitWidth: Config.notifications.width
					implicitHeight: 2 * notifCountText.implicitHeight
					opacity: 1 - mainArea.dragDelta / root.width * root.contentFadeMult
					layer.enabled: true

					StyledText {
						id: notifCountText
						anchors.centerIn: parent
						text: root.group.notifications.length > 1 ? root.group.notifications.length
																	+ " notifications" : root.group.notifications.length + " notification"
					}
				}
			}

			Column {
				id: notifColumn
				spacing: root.radiusSmall / 2
				opacity: root.group.expanded ? 1 : 0
				layer.enabled: true
				enabled: root.group.expanded

				Behavior on opacity {
					NAnim {}
				}

				// move: Transition { NAnim { properties: "y" } }

				Repeater {
					id: repeater
					model: ScriptModel {
						values: [...root.group.notifications]
					}

					NotificationWidget {
						required property NotificationData modelData
						required property int index
						notificationData: modelData
						rightMargin: Math.max(mainArea.prevX + root.x, 0)
						leftMargin: Math.max(mainArea.prevX - root.x, 0)
						maxOpacity: headerRect.opacity
						Component.onCompleted: {
							if (index === 0)
							root.firstNotification = this
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
