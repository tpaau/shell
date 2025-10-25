import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services
import qs.config

RowLayout {
	spacing: Config.spacing.small

	StyledIcon {
		text: ""
		font.pixelSize: Config.icons.size.small
	}

	CircularProgressIndicator {
		implicitHeight: parent.height - 4
		strokeWidth: 5
		indicatorColor: Theme.pallete.fg.c4
		implicitWidth: height
		progress: SystemResources.cpu.usage / 100
	}
}
