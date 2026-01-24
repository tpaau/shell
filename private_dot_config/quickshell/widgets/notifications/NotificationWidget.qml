import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils
import qs.services.notifications

// Widget representing a single notification, used by the `NotificationList` widget.
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
	readonly property real detachment:
		Utils.clamp(mainArea.dragDelta / Config.notifications.dragDismissThreshold, 0, 1)
	readonly property real topDetachment: siblingTop ?
		Math.max(siblingTop.detachment, detachment)
		: detachment
	readonly property real bottomDetachment: siblingBottom ?
		Math.max(siblingBottom.detachment, detachment)
		: detachment

	property bool expanded: false

	implicitWidth: Config.notifications.width
	implicitHeight: 50

	function dismiss() {
		Notifications.dismiss(notificationData)
	}

	// This is a dirty solution, maybe I'll manage to come up with a better one later.
	Component.onCompleted: {
		if (siblingTop) {
			if (!siblingTop.siblingBottom) siblingTop.siblingBottom = this
		}
		if (siblingBottom) {
			if (!siblingBottom.siblingTop) siblingBottom.siblingTop = this
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
					if (root.detachment === 1) {
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
		topRightRadius: Utils.lerp(root.radiusSmall, root.radiusLarge, root.topDetachment)
		topLeftRadius: topRightRadius
		bottomRightRadius: root.siblingBottom ?
			Utils.lerp(root.radiusSmall, root.radiusLarge, root.bottomDetachment)
			: root.radiusLarge
		bottomLeftRadius: bottomRightRadius

		Behavior on color { CAnim{} }
		Behavior on topRightRadius { NAnim {} }
		Behavior on bottomRightRadius { NAnim {} }

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

			Rectangle {
				id: debugBg
				color: "#000000"
				opacity: 0.5
				anchors.fill: debug
			}

			Row {
				id: debug
				spacing: 6

				component DbgText: Text {
					color: "#ffffff"
				}

				DbgText {
					text: "index: " + root.index
				}
				Column {
					spacing: 3
					DbgText {
						text: root.siblingTop ?
							"top: yes, " + root.siblingTop.index : "top: no"
						color: root.siblingTop ? "green" : "red"
					}
					DbgText {
						text: root.siblingBottom ?
							"bottom: yes, " + root.siblingBottom.index : "bottom: no"
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
}
