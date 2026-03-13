pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.services
import qs.config
import qs.services.niri

// Buttons that show up at the top of the screen when overview mode is enabled in Niri.
//
// Currently uses hardcoded animations, but I look forward to syncing them with Niri 
// automatically.

Item {
	id: root

	readonly property Item region: loader.active ? loader : null
	readonly property int spacing: Config.spacing.larger
	readonly property int buttonWidth: 160
	readonly property int buttonHeight: 60

	anchors {
		top: parent.top
		topMargin: Config.statusBar.enabled && Config.statusBar.edge === Edges.Top ?
			Config.statusBar.size : Config.screenDecorations.edges.enabled ?
			Config.screenDecorations.edges.size : 0
		horizontalCenter: parent.horizontalCenter
	}
	implicitHeight: loader.active ? buttonHeight + 2 * spacing : 0
	implicitWidth: loader.width

	Loader {
		id: loader

		anchors {
			top: parent.top
			left: parent.left
			topMargin: isClosing ? 0 : root.spacing
		}

		readonly property bool shouldBeOpen: Session.sessionDesktop == SessionDesktop.Niri && Niri.overviewOpened
		property bool isClosing: false
		onShouldBeOpenChanged: {
			if (shouldBeOpen) {
				isClosing = false
				active = true
			}
			else {
				isClosing = true
			}
		}

		Component.onCompleted: active = false

		Behavior on anchors.topMargin {
			NumberAnimation {
				duration: 200
				easing.type: Easing.OutCubic
			}
		}

		sourceComponent: RowLayout {
			id: layout

			anchors {
				centerIn: parent
				topMargin: 0
			}
			spacing: root.spacing

			opacity: 0
			Component.onCompleted: {
				opacity = Qt.binding(function () {
					return loader.isClosing ? 0 : 1
				})
			}
			onOpacityChanged: if (opacity <= 0) loader.active = false

			Behavior on opacity {
				NumberAnimation {
					duration: 200
					easing.type: Easing.OutCubic
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
				onClicked: Niri.closeAllWindows()
			}
		}

		component OverviewButton: IconAndTextButton {
			id: button

			theme: StyledButton.Theme.OnSurface
			radius: Math.min(width, height) / 2
			implicitWidth: root.buttonWidth
			implicitHeight: root.buttonHeight
			text.horizontalAlignment: Qt.AlignHCenter
		}
	}
}
