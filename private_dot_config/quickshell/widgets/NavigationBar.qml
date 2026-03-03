pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services.config
import qs.services.config.theme

Rectangle {
	id: root

	property list<NavigationBarItem> items: []

	property int padding: Config.spacing.small
	property int itemSpacing: Config.spacing.smaller
	property int contentSpacing: Config.spacing.smaller
	property int itemSize: 64
	property int buttonRadius: radius - padding
	property int activeIndex: 0
	property int buttonThemeInactive: StyledButton.Theme.SurfaceContainer
	property int buttonThemeActive: StyledButton.Theme.Primary
	property int iconThemeInactive: StyledIcon.Theme.Regular
	property int iconThemeActive: StyledIcon.Theme.Inverse
	property int textThemeInactive: StyledText.Theme.Regular
	property int textThemeActive: StyledText.Theme.Inverse
	property int direction: NavigationBar.Direction.Horizontal

	// Use a different layout for text and icon to save space (no effect if text is disabled)
	property bool compact: false
	// Only show icons, no text
	property bool iconsOnly: true

	function selectIndex(index: int): int {
		if (index < 0 || index > items.length) return 1
		activeIndex = index
		return 0
	}

	implicitWidth: grid.implicitWidth + 2 * padding
	implicitHeight: grid.implicitHeight + 2 * padding

	color: Theme.palette.surface_container
	Component.onCompleted: console.warn(`Container color: ${color}`)
	radius: Config.rounding.large

	enum Direction {
		Horizontal,
		Vertical
	}

	GridLayout {
		id: grid
		anchors.centerIn: parent
		rowSpacing: root.itemSpacing
		columnSpacing: root.itemSpacing
		rows: root.direction === NavigationBar.Direction.Horizontal ? children.length : 0
		columns: root.direction === NavigationBar.Direction.Vertical ? 0 : children.length

		Repeater {
			model: root.items

			StyledButton {
				id: button

				required property int index
				required property NavigationBarItem modelData

				readonly property int active: index === root.activeIndex

				implicitWidth: root.iconsOnly ?
					Math.max(buttonGrid.implicitWidth, buttonGrid.implicitHeight) + 2 * root.padding
					: buttonGrid.implicitWidth + 2 * root.padding
				implicitHeight: root.iconsOnly ?
					Math.max(buttonGrid.implicitWidth, buttonGrid.implicitHeight) + 2 * root.padding
					: buttonGrid.implicitHeight + 2 * root.padding
				radius: root.buttonRadius
				theme: active ? root.buttonThemeActive : root.buttonThemeInactive
				disabledOpacity: 1
				enabled: !active

				onClicked: root.selectIndex(index)
				Component.onCompleted: {
					modelData.active = active
					console.warn(`Button color: ${regularColor}`)
				}
				onActiveChanged: modelData.active = active

				GridLayout {
					id: buttonGrid
					anchors.centerIn: parent
					rows: root.compact ? 2 : 1
					columns: root.compact ? 1 : 2
					rowSpacing: root.contentSpacing
					columnSpacing: root.contentSpacing

					StyledIcon {
						id: icon
						Layout.alignment: Qt.AlignCenter
						text: button.modelData.icon
						theme: button.active ? root.iconThemeActive : root.iconThemeInactive
					}
					StyledText {
						id: text
						Layout.alignment: Qt.AlignCenter
						visible: !root.iconsOnly
						text: button.modelData.text
						theme: button.active ? root.textThemeActive : root.textThemeInactive
					}
				}
			}
		}
	}
}
