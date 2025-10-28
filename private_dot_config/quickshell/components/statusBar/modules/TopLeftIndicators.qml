pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.widgets
import qs.config
import qs.services

GridLayout {
	id: root

	required property bool isVertical

	readonly property int margin: Config.statusBar.margin
	readonly property int trayItemSize: Config.statusBar.moduleSize - margin

	implicitWidth: isVertical ? 0 : Config.statusBar.moduleSize
	implicitHeight: isVertical ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom

	IndicatorGroup {
		isVertical: root.isVertical
		topRightRadius: root.isVertical ?
			systemTray.visible || privacy.visible ? root.margin / 2 : root.margin
			: root.margin
		topLeftRadius: root.margin
		bottomRightRadius: systemTray.visible || privacy.visible ?
			root.margin / 2 : root.margin
		bottomLeftRadius: systemTray.visible || privacy.visible ?
			root.margin / 2 : root.margin

		GridLayout {
			rowSpacing: 0
			columnSpacing: 0
			flow: root.isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom

			StyledText {
				text: Time.h
				color: Theme.pallete.bg.c2
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				visible: root.isVertical
				text: ":"
				color: Theme.pallete.bg.c2
				font.weight: Config.font.weight.heavy
			}
			StyledText {
				text: Time.m
				color: Theme.pallete.bg.c2
				font.weight: Config.font.weight.heavy
			}
		}
	}
	IndicatorGroup {
		id: systemTray
		isVertical: root.isVertical
		topRightRadius: root.isVertical ?
			privacy.visible ? root.margin / 2 : root.margin : root.margin / 2
		topLeftRadius: root.margin / 2
		bottomRightRadius: privacy.visible ? root.margin / 2 : root.margin
		bottomLeftRadius: root.isVertical ?
			root.margin / 2 : privacy.visible ? root.margin / 2 : root.margin
 
		Repeater {
			id: repeater
			model: SystemTray.items

			TrayItem {
				itemSize: root.trayItemSize
			}
		}
	}
	IndicatorGroup {
		id: privacy
		isVertical: root.isVertical
		topRightRadius: root.isVertical ? root.margin : root.margin / 2
		topLeftRadius: root.margin / 2
		bottomRightRadius: root.margin
		bottomLeftRadius: root.isVertical ? root.margin / 2 : root.margin

		Item {}
	}
}
