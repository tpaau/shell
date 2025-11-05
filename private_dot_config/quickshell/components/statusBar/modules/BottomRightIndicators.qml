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

	readonly property int margin: Config.statusBar.margin
	readonly property int maxRounding: Config.statusBar.moduleSize / 2
	readonly property UPowerDevice device: UPower.displayDevice

	implicitWidth: isHorizontal ? 0 : Config.statusBar.moduleSize
	implicitHeight: isHorizontal ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	component IndicatorIcon: StyledIcon {
		color: Theme.pallete.bg.c2
		font.pixelSize: Config.icons.size.small
	}

	component StyledCircularProgressIndicator: CircularProgressIndicator {
		strokeWidth: 5
		backgroundColor: Theme.pallete.fg.c4
		indicatorColor: Theme.pallete.bg.c1
		indicatorBackgroundColor: Theme.pallete.fg.c2
		implicitWidth: height
	}

	IndicatorGroup {
		isHorizontal: root.isHorizontal
		topRightRadius: root.isHorizontal ? root.margin / 2 : root.maxRounding
		topLeftRadius: root.maxRounding
		bottomRightRadius: root.margin / 2
		bottomLeftRadius: root.isHorizontal ? root.maxRounding : root.margin / 2

		IndicatorIcon {
			text: BTService.icon
		}
		IndicatorIcon {
			visible: Cache.notifications.doNotDisturb
			text: ""
		}
		IndicatorIcon {
			visible: Caffeine.enabled
			text: ""
		}
	}
	IndicatorGroup {
		isHorizontal: root.isHorizontal
		radius: root.margin / 2

		IndicatorIcon {
			id: cpuUsageIcon
			text: ""
		}

		StyledCircularProgressIndicator {
			implicitHeight: cpuUsageIcon.height - 4
			progress: SystemResources.cpu.usage / 100
		}

		IndicatorIcon {
			id: ramUsageIcon
			text: ""
		}

		StyledCircularProgressIndicator {
			implicitHeight: ramUsageIcon.height - 4
			progress: SystemResources.ram.usage / 100
		}
	}
	IndicatorGroup {
		isHorizontal: root.isHorizontal
		topRightRadius: root.isHorizontal ? root.maxRounding : root.margin / 2
		topLeftRadius: root.margin / 2
		bottomRightRadius: root.maxRounding
		bottomLeftRadius: root.isHorizontal ? root.margin / 2 : root.maxRounding
		layout.rowSpacing: 0

		IndicatorIcon {
			Layout.alignment: Qt.AlignCenter
			text: {
				if (UPower.displayDevice.ready) {
						return Icons.pickIcon(UPower.displayDevice.percentage,
						["", "", "", "", "", "", "", ""])
				}
				else {
					return ""
				}
			}
		}

		StyledText {
			color: Theme.pallete.bg.c2
			text: {
				const val = root.device && root.device.ready ?
					Math.round(root.device.percentage * 100).toString() : 0
				if (root.isHorizontal) {
					return val + "%"
				}
				return val
			}
		}
	}
}
