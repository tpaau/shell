import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.config
import qs.services

ModuleGroup {
	StyledText {
		text: Qt.formatDateTime(Time.date, BarConfig.isHorizontal ? "MMMM" : "MMM")
		Layout.alignment: Qt.AlignCenter
		font.weight: Config.font.weight.heavy
	}
	StyledText {
		text: Qt.formatDateTime(Time.date, "d")
		Layout.alignment: Qt.AlignCenter
		font.weight: Config.font.weight.heavy
	}
}
