pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.enums
import qs.widgets
import qs.config
import qs.utils
import qs.services.niri

// Buttons that show up at the top of the screen when overview mode is enabled in Niri.
Loader {
	id: root

	readonly property Item region: active ? this : null

	anchors {
		top: parent.top
		margins: Utils.marginFromEdge(Edges.Top) - Config.wm.windowGaps
		horizontalCenter: parent.horizontalCenter
	}

	asynchronous: true
	active: false

	Connections {
		target: Niri

		function onOverviewOpenedChanged() {
			if (Niri.overviewOpened) root.active = true
		}
	}

	component OverviewButton: IconAndTextButton {
		theme: StyledButton.Theme.OnSurface
		radius: Math.min(width, height) / 2
		implicitWidth: 160
		implicitHeight: 60
		text.horizontalAlignment: Qt.AlignHCenter
	}

	sourceComponent: Row {
		id: row
		spacing: Config.spacing.normal
		opacity: 0

		anchors.top: parent.top

		component Anim: NumberAnimation {
			duration: NiriConfig.overviewOpenCloseDuration
			easing.type: NiriEasing.toAnimEasing(NiriConfig.overviewOpenCloseEasing)
		}

		ParallelAnimation {
			id: openAnim
			running: true

			Anim {
				target: row
				properties: "opacity"
				from: row.opacity
				to: 1
			}
			Anim {
				target: row
				properties: "anchors.topMargin"
				from: row.anchors.topMargin
				to: Config.wm.windowGaps
			}
		}

		ParallelAnimation {
			id: closeAnim

			Anim {
				target: row
				properties: "opacity"
				from: row.opacity
				to: 0
			}
			Anim {
				target: row
				properties: "anchors.topMargin"
				from: row.anchors.topMargin
				to: 0
			}

			onFinished: root.active = false
		}

		Connections {
			target: Niri

			function onOverviewOpenedChanged() {
				if (Niri.overviewOpened) {
					closeAnim.stop()
					openAnim.restart()
				}
				else {
					openAnim.stop()
					closeAnim.restart()
				}
			}
		}

		OverviewButton {
			text.text: "Screenshot"
			icon.text: "screenshot_frame_2"
			onClicked: Niri.screenshotWindow()
		}
		OverviewButton {
			text.text: "Close all"
			icon.text: "close"
			enabled: false
			dimmedOpacity: 1.0
			theme: StyledButton.Theme.Surface
			onClicked: Niri.closeAllWindows()
		}
	}
}
