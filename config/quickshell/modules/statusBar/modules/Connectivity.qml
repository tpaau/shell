import QtQuick
import qs.widgets
import qs.services

ModuleGroup {
	id: root

	menuOpened: networkMenu.opened || bluetoothMenu.opened

	BarButton {
		icon.text: ""
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
}
