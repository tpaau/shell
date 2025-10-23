import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services
import qs.config

RowLayout {
	spacing: 2

	StyledIcon {
		text: ""
		font.pixelSize: Appearance.icons.size.small
	}

	StyledText {
		text: SystemResources.cpu.temp + "°C"
	}
}
