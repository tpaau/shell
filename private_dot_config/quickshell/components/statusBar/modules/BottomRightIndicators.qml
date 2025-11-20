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
	readonly property UPowerDevice device: UPower.displayDevice

	implicitWidth: isHorizontal ? 0 : Config.statusBar.moduleSize
	implicitHeight: isHorizontal ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	component IndicatorIcon: StyledIcon {
		color: Theme.palette.textInverted
		font.pixelSize: Config.icons.size.small
	}

	component StyledCircularProgressIndicator: CircularProgressIndicator {
		strokeWidth: 5
		backgroundColor: indicators.color
		indicatorColor: Theme.palette.surface
		indicatorBackgroundColor: Theme.palette.accentDarker
		implicitWidth: height
	}

	ModuleGroup {
		id: indicators

		topOrLeft: null
		bottomOrRight: resourceMonitors

		isHorizontal: root.isHorizontal

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
	ModuleGroup {
		id: resourceMonitors

		topOrLeft: indicators
		bottomOrRight: power

		isHorizontal: root.isHorizontal

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

		// MouseArea {
		// 	implicitWidth: 20
		// 	implicitHeight: 20
		//
		// 	onClicked: {
		// 		testPopup.toggleOpen()
		// 	}
		//
		// 	Rectangle {
		// 		anchors.fill: parent
		// 		color: "red"
		// 	}
		//
		// 	BarPopup {
		// 		id: testPopup
		// 		component: testComp
		// 	}
		//
		// 	Component {
		// 		id: testComp
		//
		// 		Rectangle {
		// 			color: "red"
		// 			implicitWidth: 100
		// 			implicitHeight: 100
		// 		}
		// 	}
		// }
	}
	ModuleGroup {
		id: power

		topOrLeft: resourceMonitors
		bottomOrRight: null

		isHorizontal: root.isHorizontal
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
			color: Theme.palette.textInverted
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
