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
				text: {
					const h = Qt.formatDateTime(Time.date, "h")
					if (h.length == 1) return "0" + h
					return h
				}
				color: Theme.pallete.bg.c2
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				visible: root.isHorizontal
				text: ":"
				color: Theme.pallete.bg.c2
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: {
					const m = Qt.formatDateTime(Time.date, "m")
					if (m.length == 1) return "0" + m
					return m
				}
				color: Theme.pallete.bg.c2
				font.weight: Config.font.weight.heavy
			}
		}
	}
	ModuleGroup {
		id: systemTray
		topOrLeft: clock
		bottomOrRight: null
		isHorizontal: root.isHorizontal
		color: Theme.pallete.bg.c4
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
