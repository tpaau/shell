pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.animations
import qs.components.quickSettings
import qs.config
import qs.services.niri

LazyLoader {
	id: loader

	property bool isClosing: false
	property bool shouldBeOpen: Niri.overviewOpened && !quickSettings.opened

	required property QuickSettings quickSettings

	readonly property int spacing: Config.spacing.larger

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
		visible: layout.opacity > 0
		mask: Region {
			item: layout
		}

		implicitWidth: layout.width
		implicitHeight: layout.height + loader.spacing

		exclusiveZone: 0
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
				PopoutAnimation {
					duration: Config.animations.durations.shortish
				}
			}

			Behavior on opacity {
				PopoutAnimation {
					duration: Config.animations.durations.shortish
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
