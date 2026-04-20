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
	readonly property int edge: {
		switch (Config.overviewButtons.edge) {
			case Edges.Top:
				return Edges.Top
			case Edges.Bottom:
				return Edges.Bottom
			default:
				console.warn("Overview buttons can either be anchored at the top or at the bottom of the screen")
				return Edges.Top
		}
	}

	anchors {
		top: edge === Edges.Top ? parent.top : undefined
		bottom: edge === Edges.Bottom ? parent.bottom : undefined
		margins: Utils.marginFromEdge(edge) - Config.wm.windowGaps
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
		// dimmedOpacity: 1.0
		radius: Math.min(width, height) / 2
		implicitWidth: 160
		implicitHeight: 60
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
				to: root.edge === Edges.Top ? Config.wm.windowGaps : -Config.wm.windowGaps
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

		// TODO: Disable both buttons when there is no focused window
		OverviewButton {
			text.text: "Screenshot"
			icon.text: "screenshot_frame_2"
			onClicked: Niri.screenshotWindow()
		}
		OverviewButton {
			text.text: "Close"
			icon.text: "close"
			onClicked: Niri.closeWin()
		}
	}
}
