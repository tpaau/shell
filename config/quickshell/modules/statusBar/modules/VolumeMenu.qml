import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
import qs.services

BarMenu {
	id: volumeMenu
	implicitWidth: 360

	Component.onCompleted: Ipc.volumeMenuList.push(this)

	contentItem: ColumnLayout {
		spacing: Config.spacing.normal

		SinkSlider {
			Layout.leftMargin: handle.width / 2 // Don't clip the handle
			Layout.rightMargin: handle.width / 2
			implicitWidth: parent.width - handle.width / 2 // Don't clip the handle on the right
			implicitHeight: 50
		}
		SourceSlider {
			Layout.leftMargin: handle.width / 2
			Layout.rightMargin: handle.width / 2
			implicitWidth: parent.width - handle.width / 2
			implicitHeight: 50
		}
	}
}
