pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.config

LazyLoader {
	id: root

	activeAsync: Config.goofy.activateLinuxEnabled

	required property ShellScreen screen

	PanelWindow {
		id: w

		anchors {
			right: true
			bottom: true
		}
		margins {
			right: 50
			bottom: 50
		}
		implicitWidth: content.width
		implicitHeight: content.height

		screen: root.screen
		mask: Region {}
		WlrLayershell.layer: WlrLayer.Overlay

		color: "transparent"

		ColumnLayout {
			id: content

			Text {
				text: "Activate Linux"
				color: "#50ffffff"
				font.pointSize: 22
			}

			Text {
				text: "Go to Settings to activate Linux"
				color: "#50ffffff"
				font.pointSize: 14
			}
		}
	}
}
