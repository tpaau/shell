import QtQuick
import qs.config
import qs.services

Item {
	id: root

	property int timeout: Config.toast.defaultTimeout

	function restartTimer() { timer.restart() }

	Timer {
		id: timer
		interval: root.timeout
		running: true
		onTriggered: Ipc.closeToasts()
	}
}
