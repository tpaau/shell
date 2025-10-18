import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.services.niri
import qs.config

Item {
	id: root

	readonly property int margin: Appearance.spacing.larger

	Connections {
		target: Niri
		function overviewOpenedChanged() {
			console.warn(`Opened: ${Niri.overviewOpened}`)
			if (Niri.overviewOpened) {
				loader.loading = true
			}
		}
	}

	LazyLoader {
		id: loader

		onActiveChanged: {
			if (active) shouldBeOpen = true
		}
		property bool shouldBeOpen: false

		PanelWindow {
			anchors.top: true
			margins.top: margin
			visible: layout.opacity > 0

			implicitWidth: layout.width
			implicitHeight: layout.height

			exclusiveZone: 0
			color: "transparent"

			RowLayout {
				id: layout
				anchors.centerIn: parent
				spacing: root.margin

				opacity: 0
				Component.onCompleted: opacity = 1

				OverviewButton {

				}
				OverviewButton {

				}
				OverviewButton {

				}
			}

			component OverviewButton: StyledButton {
				implicitWidth: 200
				implicitHeight: 80
			}
		}
	}
}
