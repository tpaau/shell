pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.services.niri
import qs.config

Item {
	id: root

	readonly property int spacing: Appearance.spacing.larger

	LazyLoader {
		id: loader

		property bool isClosing: false
		property bool shouldBeOpen: Niri.overviewOpened
		onShouldBeOpenChanged: {
			if (shouldBeOpen) {
				isClosing = false
				loading = true
			}
			else {
				isClosing = true
			}
		}

		Item {
			PanelWindow {
				anchors.top: true
				visible: layout.opacity > 0

				implicitWidth: layout.width
				implicitHeight: layout.height + root.spacing

				exclusiveZone: 0
				color: "transparent"

				RowLayout {
					id: layout
					anchors {
						top: parent.top
						topMargin: 0
					}
					spacing: root.spacing

					opacity: 0
					Component.onCompleted: {
						opacity = Qt.binding(function () {
							return loader.isClosing ? 0 : 1
						})
						anchors.topMargin =  Qt.binding(function () {
							return loader.isClosing ? 0 : root.spacing
						})
					}
					onOpacityChanged: if (opacity <= 0) loader.active = false

					Behavior on anchors.topMargin {
						NumberAnimation {
							duration: Appearance.anims.durations.shortish
							easing.type: Appearance.anims.easings.popout
						}
					}

					Behavior on opacity {
						NumberAnimation {
							duration: Appearance.anims.durations.shortish
							easing.type: Appearance.anims.easings.popout
						}
					}

					OverviewButton {
						text.text: "Screenshot"
						icon.text: ""
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
	}
}
