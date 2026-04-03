import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs.widgets
import qs.modules.statusBar
import qs.config
import qs.theme
import qs.services

ModuleGroup {
	id: root

	color: !UPower.onBattery ?
		Theme.palette.primary : Theme.palette.surface_container
	menuOpened: powerMenu.opened
	Behavior on color { M3ColorAnim { data: batteryButton.animData } }

	readonly property real percentage:
		UPower.displayDevice?.percentage ?? 0

	StyledButton {
		id: batteryButton
		implicitWidth: BarConfig.isHorizontal ?
			column.implicitWidth + 2 * BarConfig.properties.padding
			: BarConfig.properties.size - 4 * BarConfig.properties.padding
		implicitHeight: BarConfig.isHorizontal ?
			BarConfig.properties.size - 4 * BarConfig.properties.padding
			: column.implicitHeight + 2 * BarConfig.properties.padding
		radius: (BarConfig.properties.size - 2 * BarConfig.properties.padding) / 2
		theme: !UPower.onBattery ?
			StyledButton.Theme.Primary : StyledButton.Theme.SurfaceContainer
		onClicked: powerMenu.open()

		GridLayout {
			id: column
			anchors.centerIn: parent
			rowSpacing: BarConfig.properties.spacing / 2
			columnSpacing: BarConfig.properties.spacing
			rows: 1
			columns: 1
			flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
				: GridLayout.LeftToRight

			BatteryIcon {
				id: icon
				percentage: root.percentage
				isHorizontal: BarConfig.isHorizontal
				color: UPower.onBattery ?
					Theme.palette.on_surface : Theme.palette.surface
			}
			StyledText {
				visible: Config.preferences.batteryWithPercentage
				text: BarConfig.isHorizontal ?
					`${Math.ceil(root.percentage * 100)}%`
					: Math.ceil(root.percentage * 100)
				font.pixelSize: Config.font.size.small
				Layout.alignment: Qt.AlignCenter
				theme: !UPower.onBattery ?
					StyledText.Theme.Inverse : StyledText.Theme.Regular
			}
		}

		BarMenu {
			id: powerMenu
			implicitWidth: batteryMenu.implicitWidth + 2 * padding
			implicitHeight: batteryMenu.implicitHeight + 2 * padding

			readonly property ShellScreen screen: root.screen
			Component.onCompleted: Ipc.batteryMenuList.push(this)

			contentItem: BatteryMenu {
				id: batteryMenu
			}
		}
	}
}
