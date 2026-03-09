import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services.config

ColumnLayout {
	id: root

	readonly property int spacing: Config.spacing.normal

	ScpWarningSign {
		dangerTitle: "COGNITOHAZARD"
		imageSource: Qt.resolvedUrl(Quickshell.shellDir
			+ "/assets/cognitohazard-warning-sign-white-alpha.png")
		description: "ALL DATA ON THIS DEVICE CAN BE COGNITOHAZARDOUS."
	}
}
