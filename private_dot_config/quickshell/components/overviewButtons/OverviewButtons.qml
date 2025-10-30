pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.components.quickSettings
import qs.config
import qs.services.niri

LazyLoader {
	id: loader

	readonly property int spacing: Config.spacing.larger

	required property QuickSettings quickSettings

	property bool isClosing: false
	readonly property bool shouldBeOpen:
		Niri.overviewOpened && !quickSettings.opened
	onShouldBeOpenChanged: {
		if (shouldBeOpen) {
			isClosing = false
			loading = true
		}
		else {
			isClosing = true
		}
	}

	PanelWindow {
		anchors.top: true
		implicitWidth: layout.width
		implicitHeight: layout.height + loader.spacing

		visible: layout.opacity > 0
		exclusiveZone: 0
		mask: Region {
			item: layout
		}

		color: "transparent"

		RowLayout {
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
