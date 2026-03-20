import QtQuick
import Quickshell
import qs.widgets.toast
import qs.utils
import qs.services

Toast {
	id: root

	required property ShellScreen screen

	bottomMargin: Utils.marginFromEdge(Edges.Bottom)

	Connections {
		target: Ipc

		function onDisplayIndicatorToast(comp: Component) {
			if (Ipc.quickSettingsList.length == 0) return
			if (Ipc.quickSettingsList.find(s => s.opened)) return
			root.openIfNotBusy(comp)
		}
		function onCloseToasts() {
			root.close()
		}
	}
}
