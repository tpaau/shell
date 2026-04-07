import QtQuick
import qs.modules.statusBar.modules.quickSettings
import Quickshell.Bluetooth
import qs.services

QSToggleOptionsButton {
	enabled: BTService.adapter?.state === BluetoothAdapterState.Enabled
		|| BTService.adapter?.state === BluetoothAdapterState.Disabled
		|| BTService.adapter?.state === BluetoothAdapterState.Blocked
	toggled: BTService.adapter ? BTService.adapter.enabled : false

	primaryText: "Bluetooth"
	secondaryText: BTService.stateText
	icon: BTService.icon
	innerToggle.onClicked: BTService.adapter.enabled = !BTService.adapter.enabled
	innerToggle.enabled: enabled
}

