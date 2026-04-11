import QtQuick
import Quickshell
import qs.modules.statusBar.modules
import qs.modules.statusBar.modules.quickSettings
import qs.services

BarMenu {
	id: root

	required property ShellScreen screen

	Component.onCompleted: Ipc.quickSettingsList.push(this)

	implicitWidth: content.implicitWidth + 2 * padding
	implicitHeight: content.implicitHeight + 2 * padding

	contentItem: QSContent {
		id: content
		screen: root.screen
	}
}
