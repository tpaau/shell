import QtQuick
import QtQuick.Layouts
import qs.modules.quickSettings
import qs.widgets
import qs.services.config

QSButton {
	id: root

	property bool toggled: true

	property alias icon: styledIcon.text
	property alias primaryText: textPrimary.text
	property alias secondaryText: textSecondary.text
	property alias innerToggle: innerToggle

	enabled: true
	theme: StyledButton.Theme.OnSurfaceContainer

	StyledButton {
		id: innerToggle

		Layout.fillHeight: true
		implicitWidth: height
		radius: root.radius - root.spacing

		theme: root.toggled ? StyledButton.Theme.Primary : StyledButton.Theme.OnSurface

		StyledIcon {
			id: styledIcon
			anchors.centerIn: parent
			color: innerToggle.contentColor
			text: ""
		}
	}

	ColumnLayout {
		spacing: 0

		StyledText {
			id: textPrimary
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			font.pixelSize: Config.font.size.small
			color: root.contentColor
			text: "Primary text"
		}

		StyledText {
			id: textSecondary
			Layout.alignment: Qt.AlignLeft
			Layout.fillWidth: true
			visible: text && text != ""
			font.pixelSize: Config.font.size.smaller
			color: root.contentColor
			text: "Secondary text"
		}
	}
}
