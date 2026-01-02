pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.config
import qs.utils
import qs.services

GridLayout {
	id: root

	required property bool isHorizontal
	required property BarPopup popup

	readonly property int margin: Config.statusBar.margin

	implicitWidth: isHorizontal ? 0 : Config.statusBar.moduleSize
	implicitHeight: isHorizontal ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	component IndicatorIcon: StyledIcon {
		color: Theme.palette.textInverted
		font.pixelSize: Config.icons.size.small
	}

	ModuleGroup {
		id: indicators

		visible: isHorizontal ? width > 1 || connected : height > 1 || connected
		connected: doNotDisturb.enabled || Caffeine.enabled || privacy.active

		topOrLeft: null
		bottomOrRight: resourceMonitors

		isHorizontal: root.isHorizontal

		IndicatorIcon {
			id: doNotDisturb
			readonly property bool enabled: Cache.notifications.doNotDisturb
			visible: enabled
			text: ""
		}
		IndicatorIcon {
			id: caffeine
			visible: Caffeine.enabled
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

		IndicatorIcon {
			text: ""
			Layout.preferredWidth: parent.width
		}

		IndicatorIcon {
			text: BTService.icon
		}

		IndicatorIcon {
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
