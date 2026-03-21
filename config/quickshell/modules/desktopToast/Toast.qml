import QtQuick
import Quickshell
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
			if (Ipc.quickSettingsList.find(s => s?.opened)) return
			if (Niri.focusedOutput.toShellScreen() != root.screen) return
			root.openIfNotBusy(comp)
		}
		function onCloseToasts() {
			root.close()
		}
	}
}
