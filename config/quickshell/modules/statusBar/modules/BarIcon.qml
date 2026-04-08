import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.modules.statusBar

StyledIcon {
	Layout.preferredWidth: BarConfig.properties.size - 5 * BarConfig.properties.padding
	Layout.preferredHeight: BarConfig.properties.size - 5 * BarConfig.properties.padding
	font.pixelSize: Math.min(width, height)
}
