import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.services.notifications

// Widget representing a single notification, used by the `NotificationList` widget.
Item {
	id: root

	required property NotificationData notificationData

	readonly property real contentFadeMult: 1.5

	property bool expanded: false

	implicitWidth: Config.notifications.width
	implicitHeight: 50

	function dismiss() {
		Notifications.dismiss(notificationData)
	}

	component NAnim: M3NumberAnim { data: Anims.current.effects.fast }
	component CAnim: M3ColorAnim { data: Anims.current.effects.fast }

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
		onDragDeltaChanged: contentRect.opacity =
			1 - dragDelta / width * root.contentFadeMult

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

	ClippingRectangle {
		id: wrapper
		anchors {
			fill: parent
			leftMargin:
				Math.max(mainArea.prevX - root.x, 0)
			rightMargin:
				Math.max(mainArea.prevX + root.x, 0)
		}

		color: "red"
		// color: Theme.palette.surface
		radius: Config.rounding.normal

		Behavior on color { CAnim{} }

		Rectangle {
			id: contentRect

			anchors.fill: parent
			color: mainArea.containsPress ?
				Theme.palette.surfaceBright : Theme.palette.surface
		}
	}
}
