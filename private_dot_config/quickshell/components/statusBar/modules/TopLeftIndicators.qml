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

	readonly property int maxRounding: Config.statusBar.moduleSize / 2
	readonly property int margin: Config.statusBar.margin

	implicitWidth: isHorizontal ? 0 : Config.statusBar.moduleSize
	implicitHeight: isHorizontal ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	IndicatorGroup {
		isHorizontal: root.isHorizontal
		topRightRadius: isHorizontal ?
			systemTray.visible ? root.margin / 2 : root.maxRounding
			: root.maxRounding
		topLeftRadius: root.maxRounding
		bottomRightRadius: systemTray.visible ? root.margin / 2 : root.maxRounding
		bottomLeftRadius: isHorizontal ? root.maxRounding
			: systemTray.visible ? root.margin / 2 : root.maxRounding

		GridLayout {
			rowSpacing: 0
			columnSpacing: 0
			flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

			StyledText {
				text: Qt.formatDateTime(Time.date, "h")
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
	IndicatorGroup {
		id: systemTray
		isHorizontal: root.isHorizontal
		topRightRadius: root.isHorizontal ? root.maxRounding : root.margin / 2
		topLeftRadius: root.margin / 2
		bottomRightRadius: root.maxRounding
		bottomLeftRadius: root.isHorizontal ? root.margin / 2 : root.maxRounding
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
