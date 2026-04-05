import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
import qs.services

ModuleGroup {
	id: root

	menuOpened: networkMenu.opened || bluetoothMenu.opened || volumeMenu.opened

	BarButton {
		icon.text: "signal_wifi_4_bar"
		onClicked: networkMenu.open()

		BarMenu {
			id: networkMenu
			implicitWidth: rect.implicitWidth + 2 * padding
			implicitHeight: rect.implicitHeight + 2 * padding

			contentItem: Rectangle {
				id: rect
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

			contentItem: BluetoothMenu {
				id: content
			}
		}
	}

	BarButton {
		icon.text: "headphones"
		onClicked: volumeMenu.open()

		VolumeMenu {
			id: volumeMenu
		}
	}
}
