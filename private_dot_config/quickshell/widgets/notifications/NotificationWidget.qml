import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils
import qs.services.notifications

// Widget representing a single notification, used by the `GroupedNotifications` widget.
Item {
	id: root

	required property NotificationData notificationData
	required property real rightMargin
	required property real leftMargin
	required property real maxOpacity

	property NotificationWidget siblingTop: null
	property NotificationWidget siblingBottom: null

	readonly property real contentFadeMult: 1.5
	readonly property real radiusLarge: Config.rounding.normal
	readonly property real radiusSmall: radiusLarge / 3

	// Defines visual attachment to its siblings.
	//   0 -> The widget is fully attached to its siblings
	//   1 -> The widget is fully attached it its siblings
	readonly property real detachment: Utils.clamp(mainArea.dragDelta / Config.notifications.dragDismissThreshold, 0, 1)
	readonly property real topDetachment: siblingTop ? Math.max(siblingTop.detachment, detachment) : detachment
	readonly property real bottomDetachment: siblingBottom ? Math.max(siblingBottom.detachment, detachment) : detachment

	property bool expanded: false

	implicitWidth: Config.notifications.width
	implicitHeight: wrapper.height

	function dismiss() {
		Notifications.dismiss(notificationData)
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
					if (root.detachment === 1) {
						root.dismiss()
					} else {
						root.x = 0
					}
				}
			}
		}

		onClicked: root.expanded = !root.expanded
	}

	ClippingRectangle {
		id: wrapper
		implicitWidth: parent.width
		implicitHeight: contentRect.height

		color: mainArea.containsPress && !mainArea.drag.active ? Theme.palette.surfaceBright : Theme.palette.surface
		topRightRadius: Utils.lerp(root.radiusSmall, root.radiusLarge, root.topDetachment)
		topLeftRadius: topRightRadius
		bottomRightRadius: root.siblingBottom ? Utils.lerp(root.radiusSmall, root.radiusLarge, root.bottomDetachment) : root.radiusLarge
		bottomLeftRadius: bottomRightRadius

		Behavior on color {
			CAnim {}
		}

		Item {
			id: contentRect
			implicitWidth: debug.implicitWidth
			implicitHeight: debug.implicitHeight

			opacity: Math.min(1 - mainArea.dragDelta / width * root.contentFadeMult, root.maxOpacity)

			Rectangle {
				id: debugBg
				color: "#000000"
				opacity: 0.5
				anchors.fill: debug
			}

			Row {
				id: debug
				spacing: 6

				Column {
					spacing: 3
					DbgText {
						text: "index: " + root.index
					}
					DbgText {
						text: root.notificationData.original ? root.notificationData.restored ? "state: restored" : "state: fresh" : "state: tainted"
						color: root.notificationData.original ? root.notificationData.restored ? "greenyellow" : "green" : "gray"
					}
				}
				Column {
					spacing: 3
					DbgText {
						text: root.siblingTop ? "top: yes, " + root.siblingTop.index : "top: no"
						color: root.siblingTop ? "green" : "red"
					}
					DbgText {
						text: root.siblingBottom ? "bottom: yes, " + root.siblingBottom.index : "bottom: no"
						color: root.siblingBottom ? "green" : "red"
					}
				}
				Column {
					spacing: 3
					DbgText {
						text: "topDetachment: " + root.topDetachment
					}
					DbgText {
						text: "bottomDetachment: " + root.bottomDetachment
					}
				}
			}
		}
	}

	component DbgText: Text {
		color: "white"
	}
}
