pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.widgets
import qs.config
import qs.services

GridLayout {
	id: root

	required property bool isHorizontal
	required property BarPopup popup

	readonly property int margin: Config.statusBar.margin

	implicitWidth: isHorizontal ? 0 : Config.statusBar.moduleSize
	implicitHeight: isHorizontal ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	ModuleGroup {
		id: clock

		topOrLeft: null
		bottomOrRight: systemTray
		isHorizontal: root.isHorizontal

		GridLayout {
			rowSpacing: 0
			columnSpacing: 0
			flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

			StyledText {
				text: Qt.formatDateTime(Time.date, "hh")
				color: Theme.palette.textInverted
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: ":"
				visible: root.isHorizontal
				color: Theme.palette.textInverted
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: Qt.formatDateTime(Time.date, "mm")
				color: Theme.palette.textInverted
				font.weight: Config.font.weight.heavy
			}
		}

		MouseArea {
			implicitWidth: 20
			implicitHeight: 20

			onClicked: {
				root.popup.open(testComp, this)
			}

			Rectangle {
				anchors.fill: parent
				color: "red"
			}

			Component {
				id: testComp

				Rectangle {
					color: "red"
					implicitWidth: 100
					implicitHeight: 100
				}
			}
		}
	}
	ModuleGroup {
		id: systemTray
		topOrLeft: clock
		bottomOrRight: null
		isHorizontal: root.isHorizontal
		color: Theme.palette.surfaceBright
		visible: repeater.count > 0

		Repeater {
			id: repeater
			model: SystemTray.items

			MouseArea {
				id: trayItem

				required property SystemTrayItem modelData
				readonly property real itemSize: Config.icons.size.regular

				acceptedButtons: Qt.LeftButton | Qt.RightButton
				implicitWidth: itemSize
				implicitHeight: itemSize

				IconImage {
					id: icon

					asynchronous: true
					anchors.fill: parent
					mipmap: true

					source: {
						let icon = trayItem.modelData.icon
						if (icon.includes("?path=")) {
							const [name, path] = icon.split("?path=")
							icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`
						}
						return icon
					}
				}
			}
		}
	}
}
