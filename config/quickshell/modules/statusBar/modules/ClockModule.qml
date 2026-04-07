import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.modules.statusBar
import qs.config
import qs.services

ModuleGroup {
	spacing: 0
	enabled: false

	StyledText {
		Layout.leftMargin: BarConfig.isHorizontal ? BarConfig.properties.spacing : 0
		Layout.topMargin: BarConfig.isHorizontal ? 0 : BarConfig.properties.spacing
		text: Qt.formatDateTime(Time.date, "hh")
		font.weight: Config.font.weight.heavy
	}
	StyledText {
		text: ":"
		visible: BarConfig.isHorizontal
		font.weight: Config.font.weight.heavy
	}
	StyledText {
		Layout.rightMargin: BarConfig.isHorizontal ? BarConfig.properties.spacing : 0
		Layout.bottomMargin: BarConfig.isHorizontal ? 0 : BarConfig.properties.spacing
		text: Qt.formatDateTime(Time.date, "mm")
		font.weight: Config.font.weight.heavy
	}
}
