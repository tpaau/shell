import QtQuick
import qs.widgets
import qs.modules.statusBar
import qs.config
import qs.services

ModuleGroup {
	spacing: 0

	StyledText {
		text: Qt.formatDateTime(Time.date, "hh")
		font.weight: Config.font.weight.heavy
	}
	StyledText {
		text: ":"
		visible: BarConfig.isHorizontal
		font.weight: Config.font.weight.heavy
	}
	StyledText {
		text: Qt.formatDateTime(Time.date, "mm")
		font.weight: Config.font.weight.heavy
	}
}
