import QtQuick
import qs.components.quickSettings
import Quickshell.Bluetooth
import qs.services

QSToggleOptionsButton {
	enabled: BTService.adapter?.state != BluetoothAdapterState.Enabling
		&& BTService.adapter?.state != BluetoothAdapterState.Disabling
	toggled: BTService.adapter ? BTService.adapter.enabled : false

	primaryText: "Bluetooth"
	secondaryText: BTService.stateText
	icon: BTService.icon
	innerToggle.onClicked: BTService.adapter.enabled = !BTService.adapter.enabled
}

