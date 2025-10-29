import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
import qs.services

GridLayout {
	id: root

	required property bool isVertical

	readonly property int margin: Config.statusBar.margin

	implicitWidth: isVertical ? 0 : Config.statusBar.moduleSize
	implicitHeight: isVertical ? Config.statusBar.moduleSize : 0

	columnSpacing: margin / 2
	rowSpacing: margin / 2
	flow: root.isVertical ? GridLayout.LeftToRight : GridLayout.TopToBottom

	component IndicatorIcon: StyledIcon {
		color: Theme.pallete.bg.c2
		font.pixelSize: Config.icons.size.small
	}

	IndicatorGroup {
		isVertical: root.isVertical
		topRightRadius: root.isVertical ? root.margin / 2 : root.margin
		topLeftRadius: root.margin
		bottomRightRadius: root.margin / 2
		bottomLeftRadius: root.isVertical ? root.margin : root.margin / 2

		IndicatorIcon {
			text: BTService.icon
		}
		IndicatorIcon {
			visible: Cache.notifications.doNotDisturb
			text: ""
		}
		IndicatorIcon {
			visible: Caffeine.enabled
			text: ""
		}
	}
	IndicatorGroup {
		isVertical: root.isVertical
		radius: root.margin / 2

		Item {
			implicitWidth: 1
			implicitHeight: 1
		}
	}
	IndicatorGroup {
		isVertical: root.isVertical
		topRightRadius: root.isVertical ? root.margin : root.margin / 2
		topLeftRadius: root.margin / 2
		bottomRightRadius: root.margin
		bottomLeftRadius: root.isVertical ? root.margin / 2 : root.margin

		Item {
			implicitWidth: 1
			implicitHeight: 1
		}
	}
}
