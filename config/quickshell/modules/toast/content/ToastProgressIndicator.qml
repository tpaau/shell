import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
import qs.services

RowLayout {
	id: root

	required property string icon
	required property real progress
	property int timeout: Config.toast.defaultTimeout

	function restartTimer() { timer.restart() }

	spacing: Config.spacing.normal

	Timer {
		id: timer
		interval: root.timeout
		running: true
		onTriggered: Ipc.toast?.close()
	}
	StyledIcon {
		id: icon
		text: root.icon
		font.pixelSize: Config.icons.size.larger
	}
	ProgressIndicator {
		implicitWidth: 300
		implicitHeight: 6
		progress: root.progress
		Layout.rightMargin: icon.width / 4
	}
}
