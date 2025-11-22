pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications
import qs.widgets
import qs.config

PopoutShape {
	id: root

	anchors {
		right: parent.right
		top: parent.top
		topMargin: (Config.statusBar.enabled
			&& Config.statusBar.edge === Edges.Top ?
			Config.statusBar.size : 0) - 1
		rightMargin: (Config.statusBar.enabled
			&& Config.statusBar.edge === Edges.Right ?
			Config.statusBar.size : 0) - 1
	}
	implicitHeight: layout.children.length > 0 ?
		scroll.height + 1.5 * root.spacing : 0
	implicitWidth: scroll.width + 3 * root.spacing

	alignment: PopoutAlignment.topRight
	clip: true

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
		// inlineReplySupported: true
		bodyHyperlinksSupported: true
		persistenceSupported: true
		// actionIconsSupported: true

		onNotification: function(notification) {
			notification.tracked = true
			notifWidgetSrc.createObject(layout, {
				notif: notification
			})
		}
	}

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
