import QtQuick.Layouts
import qs.widgets
import qs.config

StyledButton {
	id: root
	implicitWidth: Config.quickSettings.buttonWidth
	implicitHeight: Config.quickSettings.buttonHeight
	radius: Config.rounding.large
	theme: StyledButton.Theme.OnSurfaceContainer
	clip: true

	property int spacing: radius / 3

	default property alias data: layout.data

	RowLayout {
		id: layout
		spacing: root.spacing

		anchors {
			fill: parent
			margins: root.spacing
		}
	}
}
