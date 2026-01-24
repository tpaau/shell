pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.services.notifications

// Notification group, eg. notifications from a particular app.
Item {
	id: root

	required property NotificationGroup group

	readonly property real contentFadeMult: 1.5
	readonly property real radiusLarge: Config.rounding.normal
	readonly property real radiusSmall: radiusLarge / 3

	property bool expanded: false

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

		onClicked: root.expanded = !root.expanded
	}

	Column {
		id: mainLayout
		spacing: root.radiusSmall / 2

		ClippingRectangle {
			id: wrapper
			anchors {
				left: parent.left
				leftMargin: root.x < 0 ? mainArea.dragDelta : 0
			}
			implicitWidth: parent.width - mainArea.dragDelta
			implicitHeight: headerRect.implicitHeight

			color: "red"
			// color: Theme.palette.surface
			radius: root.radiusLarge
			bottomRightRadius: root.radiusSmall
			bottomLeftRadius: root.radiusSmall

			Behavior on color { CAnim{} }

			Rectangle {
				id: headerRect

				implicitWidth: root.width
				implicitHeight: 30

				opacity: 1 - mainArea.dragDelta / width * root.contentFadeMult
				color: mainArea.containsPress ?
					Theme.palette.surfaceBright : Theme.palette.surface

				Behavior on color {
					M3ColorAnim { data: Anims.current.effects.fast }
				}
			}
		}

		Column {
			spacing: root.radiusSmall / 2

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
					contactBottom: index < repeater.model.length - 1
				}
			}
		}
	}
}
