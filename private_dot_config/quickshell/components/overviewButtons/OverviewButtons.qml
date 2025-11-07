pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.config
import qs.services.niri

Loader {
	id: loader

	active: false
	asynchronous: true

	anchors {
		top: parent.top
		topMargin: Config.statusBar.enabled && Config.statusBar.edge == Edges.Top ?
		Config.statusBar.size : Config.screenDecorations.edges.enabled ?
		Config.screenDecorations.edges.size : 0
	}
	x: (parent.width - width) / 2

	readonly property int spacing: Config.spacing.larger

	property bool isClosing: false
	readonly property bool shouldBeOpen: Niri.overviewOpened
	onShouldBeOpenChanged: {
		if (shouldBeOpen) {
			isClosing = false
			active = true
		}
		else {
			isClosing = true
		}
	}

	sourceComponent: RowLayout {
		id: layout

		anchors {
			top: parent.top
			topMargin: 0
		}
		spacing: loader.spacing

		opacity: 0
		Component.onCompleted: {
			opacity = Qt.binding(function () {
				return loader.isClosing ? 0 : 1
			})
			anchors.topMargin =  Qt.binding(function () {
				return loader.isClosing ? 0 : loader.spacing
			})
		}
		onOpacityChanged: if (opacity <= 0) loader.active = false

		Behavior on anchors.topMargin {
			NumberAnimation {
				duration: Config.animations.durations.popout
				easing.type: Config.animations.easings.popout
			}
		}

		Behavior on opacity {
			NumberAnimation {
				duration: Config.animations.durations.popout
				easing.type: Config.animations.easings.popout
			}
		}

		OverviewButton {
			text.text: "Screenshot"
			icon.text: ""
			onClicked: Niri.screenshotWindow()
		}
		OverviewButton {
			text.text: "Close all"
			icon.text: ""
			onClicked: Niri.closeAllWindows()
		}
	}

	component OverviewButton: StyledButton {
		id: button
		property alias text: text
		property alias icon: icon

		rect.radius: Math.min(rect.width, rect.height) / 2
		implicitWidth: 160
		implicitHeight: 60

		RowLayout {
			id: buttonLayout
			anchors.centerIn: parent
			StyledIcon {
				id: icon
				text: "a"
			}
			StyledText {
				id: text
				horizontalAlignment: Qt.AlignHCenter
			}
		}
	}
}
