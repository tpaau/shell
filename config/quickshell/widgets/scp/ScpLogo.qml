import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.services.config

RowLayout {
	spacing: Config.spacing.normal

	IconImage {
		implicitSize: 35
		Layout.alignment: Qt.AlignCenter
		Layout.topMargin: 3
		source: Qt.resolvedUrl(
			Quickshell.shellDir + "/assets/scp-logo-white.png")
	}

	ColumnLayout {
		spacing: Config.spacing.smaller

		StyledText {
			text: "SCP Foundation"
			font.weight: Config.font.weight.heavy
		}

		StyledText {
			text: "Secure. Contain. Protect."
			font.pixelSize: Config.font.size.smaller
		}
	}
}
