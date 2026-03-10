pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.widgets.notifications
import qs.modules.statusBar.modules
import qs.services
import qs.services.notifications
import qs.services.config
import qs.services.config.theme

GridLayout {
	id: root

	required property bool isHorizontal

	readonly property bool menuOpened: notificationsMenu.opened
		|| caffeineMenu.opened
		|| networkMenu.opened
		|| bluetoothMenu.opened
		|| powerMenu.opened

	implicitWidth: isHorizontal ? 0 : Config.statusBar.size - 2 * Config.statusBar.padding
	implicitHeight: isHorizontal ? Config.statusBar.size - 2 * Config.statusBar.padding : 0

	columnSpacing: Config.statusBar.spacing / 2
	rowSpacing: Config.statusBar.spacing / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	ModuleGroup {
		id: temporalIndicators

		visible: isHorizontal ? width > 1 || connected : height > 1 || connected
		connected: notifications.enabled || caffeine.enabled || privacy.active
		color: Theme.palette.primary
		topOrLeft: null
		bottomOrRight: staticIndicators
		isHorizontal: root.isHorizontal

		BarButton {
			id: notifications
			visible: enabled
			onClicked: notificationsMenu.open()
			theme: StyledButton.Theme.Primary
			regularColor: Qt.alpha(Theme.palette.primary, 0)
			readonly property bool enabled: Notifications.doNotDisturb
				|| Notifications.notifications.length > 0
				|| notificationsMenu.visible

			icon {
				color: Theme.palette.surface
				text: {
					if (!Notifications.doNotDisturb && Notifications.notifications.length == 0) {
						return "notifications"
					} else {
						return Notifications.doNotDisturb ?
							"notifications_off" : "notifications_unread"
					}
				}
			}

			BarMenu {
				id: notificationsMenu
				implicitWidth: list.implicitWidth + 2 * padding
				implicitHeight: list.implicitHeight + 2 * padding

				NotificationList {
					id: list
				}
			}
		}
		BarButton {
			id: caffeine
			visible: enabled
			enabled: Caffeine.running || caffeineMenu.visible
			onClicked: caffeineMenu.open()
			theme: StyledButton.Theme.Primary
			regularColor: Qt.alpha(Theme.palette.primary, 0)

			icon {
				color: Theme.palette.surface
				text: ""
			}

			BarMenu {
				id: caffeineMenu
				implicitWidth: button.implicitWidth + 2 * padding
				implicitHeight: button.implicitHeight + 2 * padding

				StyledButton {
					id: button
					implicitWidth: 100
					implicitHeight: 100
					onClicked: Caffeine.setRunning(false)
				}
			}
		}
		Privacy {
			id: privacy
			isHorizontal: root.isHorizontal
		}
	}

	ModuleGroup {
		id: staticIndicators

		topOrLeft: temporalIndicators
		bottomOrRight: batteryModule

		isHorizontal: root.isHorizontal

		BarButton {
			icon.text: ""
			onClicked: networkMenu.open()

			BarMenu {
				id: networkMenu
				implicitWidth: rect3.implicitWidth + 2 * padding
				implicitHeight: rect3.implicitHeight + 2 * padding

				Rectangle {
					id: rect3
					implicitWidth: 100
					implicitHeight: 100
					color: "red"
				}
			}
		}

		BarButton {
			icon.text: BTService.icon
			onClicked: bluetoothMenu.open()

			BarMenu {
				id: bluetoothMenu
				implicitWidth: content.implicitWidth + 2 * padding
				implicitHeight: content.implicitHeight + 2 * padding

				BluetoothMenu {
					id: content
				}
			}
		}
	}

	ModuleGroup {
		id: batteryModule

		topOrLeft: staticIndicators
		bottomOrRight: null
		isHorizontal: root.isHorizontal
		color: !UPower.onBattery ?
			Theme.palette.primary : Theme.palette.surface_container_high
		Behavior on color { M3ColorAnim { data: batteryButton.animData } }

		readonly property real percentage:
			UPower.displayDevice?.percentage ?? 0

		StyledButton {
			id: batteryButton
			implicitWidth: root.isHorizontal ?
				column.implicitWidth + 2 * Config.statusBar.padding
				: Config.statusBar.size - 4 * Config.statusBar.padding
			implicitHeight: root.isHorizontal ?
				Config.statusBar.size - 4 * Config.statusBar.padding
				: column.implicitHeight + 2 * Config.statusBar.padding
			radius: (Config.statusBar.size - 2 * Config.statusBar.padding) / 2
			theme: !UPower.onBattery ?
				StyledButton.Theme.Primary : StyledButton.Theme.OnSurfaceContainer
			onClicked: powerMenu.open()

			GridLayout {
				id: column
				anchors.centerIn: parent
				rowSpacing: Config.statusBar.spacing / 2
				columnSpacing: Config.statusBar.spacing
				rows: 1
				columns: 1
				flow: root.isHorizontal ? GridLayout.TopToBottom
					: GridLayout.LeftToRight


				BatteryIcon {
					id: icon
					percentage: batteryModule.percentage
					isHorizontal: root.isHorizontal
					theme: !UPower.onBattery ?
						StyledIcon.Theme.Inverse : StyledIcon.Theme.Regular
				}
				StyledText {
					visible: Config.preferences.batteryWithPercentage
					text: root.isHorizontal ?
						`${Math.round(batteryModule.percentage * 100)}%`
						: Math.round(batteryModule.percentage * 100)
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

				BatteryMenu {
					id: batteryMenu
				}
			}
		}
	}
}
