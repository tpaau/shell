import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.services.notifications

// Widget representing a single notification, used by the `NotificationList` widget.
Item {
	id: root

	required property NotificationData notificationData
	required property real rightMargin
	required property real leftMargin
	required property real maxOpacity
	required property bool contactBottom

	readonly property real contentFadeMult: 1.5
	readonly property real radiusLarge: Config.rounding.normal
	readonly property real radiusSmall: radiusLarge / 3

	property bool expanded: false

	implicitWidth: Config.notifications.width
	implicitHeight: 50

	function dismiss() {
		Notifications.dismiss(notificationData)
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

	ClippingRectangle {
		id: wrapper
		anchors {
			fill: parent
			rightMargin:
				Math.max(Math.max(mainArea.prevX + root.x, root.rightMargin), 0)
			leftMargin:
				Math.max(Math.max(mainArea.prevX - root.x, root.leftMargin), 0)
		}

		color: "red"
		// color: Theme.palette.surface
		radius: root.radiusSmall
		bottomRightRadius: root.contactBottom ? root.radiusSmall : root.radiusLarge
		bottomLeftRadius: bottomRightRadius

		Behavior on color { CAnim{} }

		Rectangle {
			id: contentRect
			anchors.fill: parent

			opacity: Math.min(
				1 - mainArea.dragDelta / width * root.contentFadeMult,
				root.maxOpacity
			)
			color: mainArea.containsPress ?
				Theme.palette.surfaceBright : Theme.palette.surface

			Behavior on color {
				M3ColorAnim { data: Anims.current.effects.fast }
			}
		}
	}
}
