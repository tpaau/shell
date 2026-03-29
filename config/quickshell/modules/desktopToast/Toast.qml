pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs.widgets
import qs.widgets.toast
import qs.config
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
			root.openIfNotBusy(comp)
		}
		function onCloseToasts() {
			root.close()
		}
	}

	LazyLoader {
		active: PowerProfiles.hasPerformanceProfile ?? false

		Component {
			id: powerProfileComponent
			ToastPowerProfileIndicator {}
		}

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
