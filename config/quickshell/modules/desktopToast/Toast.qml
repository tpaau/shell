pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.UPower
import qs.widgets.toast
import qs.utils
import qs.services
import qs.services.niri

Toast {
	id: root

	required property ShellScreen screen

	bottomMargin: Utils.marginFromEdge(Edges.Bottom)

	Connections {
		target: Ipc

		function onDisplayIndicatorToast(comp: Component) {
			if (Niri.focusedOutput.toShellScreen() != root.screen) return
			if (Ipc.quickSettingsList.find(s => s.opened)) return
			if (Ipc.volumeMenuList.find(m => m.opened)) return
			root.openIfNotBusy(comp)
		}
		function onCloseToasts() {
			root.close()
		}
	}

	Component {
		id: powerProfileComponent
		ToastPowerProfileIndicator {}
	}

	LazyLoader {
		active: PowerProfiles.hasPerformanceProfile ?? false

		Connections {
			target: PowerProfiles

			function onProfileChanged() {
				if (Niri.focusedOutput.toShellScreen() != root.screen) return
				if (Ipc.batteryMenuList.find(m => m.opened)) return
				root.openIfNotBusy(powerProfileComponent)
			}
		}
	}
}
