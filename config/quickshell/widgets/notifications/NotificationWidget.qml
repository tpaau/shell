import QtQuick
import Quickshell.Widgets
import qs.widgets
import qs.utils
import qs.services.notifications
import qs.widgets.notifications
import qs.config
import qs.theme

// Widget representing a single notification, used by the `GroupedNotifications` widget.
Item {
	id: root

	required property NotificationData notificationData
	required property M3AnimData regularAnimData
	required property M3AnimData fastAnimData
	required property real rightMargin
	required property real leftMargin
	required property real maxOpacity
	required property int radiusLarge
	required property int radiusSmall
	required property int padding
	required property int iconSize
	required property bool showAppName

	property NotificationWidget siblingTop: null
	property NotificationWidget siblingBottom: null

	readonly property real contentFadeMult: 1.5
	readonly property int closing: closeAnim.running

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

	implicitWidth: Config.notifications.width
	implicitHeight: wrapper.implicitHeight + Math.floor(root.radiusSmall / 2)

	function dismiss() {
		Notifications.dismiss(notificationData)
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
			property: "implicitHeight"
			to: 0
		}
		FastAnim {
			target: root
			property: "detachment"
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

		onClicked: root.notificationData.expanded = !root.notificationData.expanded
	}

	ClippingRectangle {
		id: wrapper
		implicitWidth: parent.width
		implicitHeight: loader.implicitHeight + 2 * root.padding

		color: mainArea.containsPress && !mainArea.drag.active ?
			Theme.palette.surface_container : Theme.palette.surface_container_low
		topRightRadius: Utils.lerp(root.radiusSmall, root.radiusLarge, root.topDetachment)
		topLeftRadius: topRightRadius
		bottomRightRadius: root.siblingBottom ?
			Utils.lerp(root.radiusSmall, root.radiusLarge, root.bottomDetachment)
			: root.radiusLarge
		bottomLeftRadius: bottomRightRadius

		Behavior on color { CAnim{} }

		Loader {
			id: loader
			anchors.centerIn: parent
			// asynchronous: true // Don't, causes the notification list to scroll when the model changes
			layer.enabled: true
			opacity: Math.min(
				1 - mainArea.dragDelta / width * root.contentFadeMult,
				root.maxOpacity
			)
			sourceComponent: NotificationWidgetContent {
				notif: root.notificationData
				padding: root.padding
				desiredWidth: root.width - 2 * root.padding
				iconSize: root.iconSize
				showAppName: root.showAppName
			}
		}
	}
}
