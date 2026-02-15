pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.widgets.notifications
import qs.config
import qs.utils
import qs.services
import qs.services.notifications

GridLayout {
	id: root

	required property bool isHorizontal
	required property BarPopup popup

	implicitWidth: isHorizontal ? 0 : Config.statusBar.size - 2 * Config.statusBar.padding
	implicitHeight: isHorizontal ? Config.statusBar.size - 2 * Config.statusBar.padding : 0

	columnSpacing: Config.statusBar.spacing / 2
	rowSpacing: Config.statusBar.spacing / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	component IndicatorIcon: StyledIcon {
		font.pixelSize: Config.icons.size.small
	}

	ModuleGroup {
		id: indicators

		visible: isHorizontal ? width > 1 || connected : height > 1 || connected
		connected: doNotDisturb.enabled || Caffeine.running || privacy.active
		color: Theme.palette.accentDark

		topOrLeft: null
		bottomOrRight: resourceMonitors

		isHorizontal: root.isHorizontal

		StyledButton {
			visible: doNotDisturb.enabled
			onClicked: root.popup.open(ignoredNotifications, this)
			implicitWidth: 1.5 * doNotDisturb.implicitWidth
			implicitHeight: implicitWidth
			theme: StyledButton.Theme.Bright
			regularColor: Qt.alpha(Theme.palette.buttonBrightRegular, 0)
			radius: Config.rounding.small

			Component {
				id: ignoredNotifications
				NotificationList {}
			}

			StyledIcon {
				id: doNotDisturb
				anchors.centerIn: parent
				font.pixelSize: Config.icons.size.small
				color: Theme.palette.textInverted
				readonly property bool enabled: Notifications.doNotDisturb
					|| Notifications.notifications.length > 0
				visible: enabled
				text: Notifications.doNotDisturb ?
					"notifications_off" : "notifications_unread"
			}
		}
		StyledIcon {
			id: caffeine
			font.pixelSize: Config.icons.size.small
			color: Theme.palette.textInverted
			visible: Caffeine.running
			text: ""
		}
		Privacy {
			id: privacy
			isHorizontal: root.isHorizontal
		}
	}

	ModuleGroup {
		id: resourceMonitors

		topOrLeft: indicators
		bottomOrRight: null

		isHorizontal: root.isHorizontal

		StyledIcon {
			text: ""
			font.pixelSize: Config.icons.size.small
			Layout.preferredWidth: parent.width
		}

		StyledIcon {
			text: BTService.icon
			font.pixelSize: Config.icons.size.small
		}

		StyledIcon {
			readonly property UPowerDevice device: UPower.displayDevice
			readonly property real percentage: device?.ready ? device.percentage : 0
			property bool isHorizontal: root.isHorizontal
			readonly property list<string> iconsHorizontal: ["", "", "", "", "", "", "", ""]
			readonly property list<string> iconsVertical: ["", "", "", "", "", "", "", ""]
			readonly property list<string> iconsCurrent: isHorizontal ?
				iconsHorizontal : iconsVertical
			fill: 0
			font.pixelSize: Config.icons.size.regular
			text: Icons.pickIcon(percentage, iconsCurrent)
		}
	}
}
