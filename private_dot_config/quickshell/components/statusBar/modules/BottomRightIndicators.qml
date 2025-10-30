import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.config
import qs.utils
import qs.services

GridLayout {
	id: root

	required property bool isVertical

	readonly property int margin: Config.statusBar.margin
	readonly property int maxRounding: Config.statusBar.moduleSize / 2
	readonly property UPowerDevice device: UPower.displayDevice

	implicitWidth: isVertical ? 0 : Config.statusBar.moduleSize
	implicitHeight: isVertical ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom

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
		isVertical: root.isVertical
		topRightRadius: root.isVertical ? root.margin / 2 : root.maxRounding
		topLeftRadius: root.maxRounding
		bottomRightRadius: root.margin / 2
		bottomLeftRadius: root.isVertical ? root.maxRounding : root.margin / 2

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
		isVertical: root.isVertical
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
		isVertical: root.isVertical
		topRightRadius: root.isVertical ? root.maxRounding : root.margin / 2
		topLeftRadius: root.margin / 2
		bottomRightRadius: root.maxRounding
		bottomLeftRadius: root.isVertical ? root.margin / 2 : root.maxRounding
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
				if (root.isVertical) {
					return val + "%"
				}
				return val
			}
		}
	}
}
