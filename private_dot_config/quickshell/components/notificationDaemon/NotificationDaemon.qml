pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications
import qs.widgets
import qs.config

PanelWindow {
	id: root
	color: "transparent"

	exclusiveZone: 0
	anchors {
		right: true
		top: true
		bottom: true
	}
	implicitWidth: Config.notifications.width + 3 * spacing
	visible: layout.children.length > 0 || shape.height > 0

	mask: Region {
		item: shape
	}

	readonly property real spacing: Config.rounding.popout

	Component {
		id: notifWidgetSrc
		NotificationWidget {
			spacing: root.spacing
		}
	}

	NotificationServer {
		id: server

		keepOnReload: false
		imageSupported: true
		actionsSupported: true
		inlineReplySupported: true
		bodyHyperlinksSupported: true
		persistenceSupported: true
        actionIconsSupported: true
        bodyMarkupSupported: true

        onNotification: function(notification) {
			notification.tracked = true
			notifWidgetSrc.createObject(layout, {
				notif: notification
			})
        }
    }

	PopoutShape {
		id: shape
		anchors {
			left: parent.left
			right: parent.right
			top: parent.top
			topMargin: -1
			rightMargin: -1
		}
		alignment: PopoutAlignment.topRight
		clip: true

		readonly property bool isOpen: layout.children.length > 0
		height: isOpen ? scroll.height + 1.5 * root.spacing : 0

		ScrollView {
			id: scroll

			anchors {
				top: parent.top
				right: parent.right
				rightMargin: root.spacing
			}
			implicitHeight: Math.min(layout.height,
				Config.notifications.maxWrapperHeight)

			contentItem.layer.enabled: true
			contentItem.layer.effect: MultiEffect {
				maskEnabled: true
				maskSpreadAtMin: 1
				maskThresholdMin: 0.5
				maskSource: Rectangle {
					parent: scroll
					visible: false
					radius: Config.rounding.small
					layer.enabled: true
					anchors.fill: scroll
				}
			}

			contentChildren: [
				ColumnLayout {
					id: layout
					spacing: 0
				}
			]
		}
	}
}
