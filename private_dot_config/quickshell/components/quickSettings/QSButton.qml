import QtQuick.Layouts
import qs.widgets
import qs.config

StyledButton {
	id: root
	implicitWidth: Config.quickSettings.buttonWidth
	implicitHeight: Config.quickSettings.buttonHeight
	radius: Math.min(width, height) / 3
	clip: true

	default property alias data: layout.data

	RowLayout {
		id: layout
		spacing: root.radius / 2

		anchors {
			fill: parent
			margins: root.radius / 2
		}
	}
}
