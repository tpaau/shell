import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.modules.statusBar
import qs.config
import qs.services

ModuleGroup {
	id: root

	theme: UPower.onBattery ? StyledButton.SurfaceContainer : StyledButton.Primary
	menuOpened: powerMenu.opened

	readonly property real percentage:
		UPower.displayDevice?.percentage ?? 0

	onClicked: powerMenu.open()

	BatteryIcon {
		id: icon
		percentage: root.percentage
		isHorizontal: BarConfig.isHorizontal
		Layout.preferredWidth: BarConfig.properties.size - 5 * BarConfig.properties.padding
		Layout.preferredHeight: BarConfig.properties.size - 5 * BarConfig.properties.padding
		font.pixelSize: Math.min(width, height)
		color: root.contentColor
	}
	StyledText {
		visible: Config.preferences.batteryWithPercentage
		text: BarConfig.isHorizontal ?
			`${Math.ceil(root.percentage * 100)}%`
			: Math.ceil(root.percentage * 100)
		font.pixelSize: Config.font.size.small
		Layout.alignment: Qt.AlignCenter
		color: root.contentColor
	}

	BarMenu {
		id: powerMenu
		screen: root.screen
		implicitWidth: content.implicitWidth + 2 * padding
		implicitHeight: content.implicitHeight + 2 * padding

		Component.onCompleted: Ipc.batteryMenuList.push(this)

		contentItem: BatteryMenu {
			id: content
		}
	}
}
