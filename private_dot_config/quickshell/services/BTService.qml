pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
	id: root
	readonly property BluetoothAdapter adapter: Bluetooth.defaultAdapter
	readonly property bool enabled:
		adapter?.state == BluetoothAdapterState.Enabled

	property string stateText: "unknown"
	property string icon: ""

	readonly property list<BluetoothDevice> connected: {
		let conn = []
		for (let i = 0; i < adapter?.devices.values.length; i++) {
			if (adapter?.devices.values[i].connected) {
				conn.push(adapter?.devices.values[i])
			}
		}
		Qt.callLater(conns.reloadStuff)
		return conn
	}

	Connections {
		id: conns
		target: root.adapter

		Component.onCompleted: reloadStuff()
		function onStateChanged() {
			reloadStuff()
		}

		function reloadStuff() {
			switch (root.adapter?.state) {
				case BluetoothAdapterState.Disabled:
					root.icon = ""
					root.stateText = "Disabled"
					return
				case BluetoothAdapterState.Blocked:
					root.icon = ""
					root.stateText = "Blocked"
					return
				case BluetoothAdapterState.Enabled:
					if (root.connected.length > 0) {
						root.icon = ""
						if (root.connected.length == 1) {
							root.stateText
								= root.connected.length + " device connected"
						}
						else {
							root.stateText
								= root.connected.length + " devices connected"
						}
					}
					else {
						root.icon = ""
						root.stateText = "Enabled"
					}
					return
				case BluetoothAdapterState.Enabling:
					root.stateText = "Enabling"
					return
				case BluetoothAdapterState.Disabling:
					root.stateText = "Disabling"
					return
			}
		}
	}
}
