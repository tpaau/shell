import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils
import qs.services.notifications
import qs.widgets.notifications

// Widget representing a single notification, used by the `GroupedNotifications` widget.
Item {
	id: root

	required property NotificationData notificationData
	required property real rightMargin
	required property real leftMargin
	required property real maxOpacity

	property NotificationWidget siblingTop: null
	property NotificationWidget siblingBottom: null

	readonly property int closing: closeAnim.running
	readonly property real contentFadeMult: 1.5
	readonly property real radiusLarge: Config.rounding.normal
	readonly property real radiusSmall: radiusLarge / 3

	// Defines visual attachment to its siblings.
	//   0 -> The widget is fully attached to its siblings
	//   1 -> The widget is fully attached it its siblings
	property real detachment:
		Utils.clamp(mainArea.dragDelta / Config.notifications.dragDismissThreshold, 0, 1)
	readonly property real topDetachment: siblingTop ?
		Math.max(siblingTop.detachment, detachment)
		: detachment
	readonly property real bottomDetachment: siblingBottom ?
		siblingBottom.closing ? 1
		: Math.max(siblingBottom.detachment, detachment)
	: detachment

	property bool expanded: false

	implicitWidth: Config.notifications.width
	implicitHeight: wrapper.implicitHeight + Math.floor(Config.rounding.normal / 6)
	clip: true

	function dismiss() {
		Notifications.dismiss(notificationData)
	}

	component NAnim: M3NumberAnim { data: Anims.current.effects.regular }
	component CAnim: M3ColorAnim { data: Anims.current.effects.regular }
	component FastAnim: M3NumberAnim { data: Anims.current.effects.fast }

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
		FastAnim {
			target: root
			property: "detachment"
			from: 1
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
			target: xRestoreAnim.running ? null : parent
			axis: Drag.XAxis

			onActiveChanged: {
				if (drag.active) {
					prevX = root.x
				} else {
					if (root.detachment === 1) {
						closeAnim.running = true
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
		implicitHeight: loader.height

		color: mainArea.containsPress && !mainArea.drag.active ?
			Theme.palette.surfaceBright : Theme.palette.surface
		topRightRadius: Utils.lerp(root.radiusSmall, root.radiusLarge, root.topDetachment)
		topLeftRadius: topRightRadius
		bottomRightRadius: root.siblingBottom ?
			Utils.lerp(root.radiusSmall, root.radiusLarge, root.bottomDetachment)
			: root.radiusLarge
		bottomLeftRadius: bottomRightRadius

		Behavior on color { CAnim{} }

		Loader {
			id: loader
			width: parent.width
			opacity: Math.min(
				1 - mainArea.dragDelta / width * root.contentFadeMult,
				root.maxOpacity
			)
			layer.enabled: true
			// asynchronous: true
			sourceComponent: NotificationWidgetContent {}
		}
	}
}
