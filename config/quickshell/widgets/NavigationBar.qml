pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.models
import qs.services.config
import qs.services.config.theme

Rectangle {
	id: root

	property list<EntryContent> model: []

	property int padding: Config.spacing.small
	property int itemSpacing: Config.spacing.smaller
	property int contentSpacing: Config.spacing.smaller
	property int buttonRadius: radius - padding
	property int selectedIndex: 0
	property int buttonThemeNotSelected: StyledButton.Theme.SurfaceContainer
	property int buttonThemeSelected: StyledButton.Theme.Primary
	property int iconThemeNotSelected: StyledIcon.Theme.Regular
	property int iconThemeSelected: StyledIcon.Theme.Inverse
	property int textThemeNotSelected: StyledText.Theme.Regular
	property int textThemeSelected: StyledText.Theme.Inverse
	property int direction: NavigationBar.Direction.Horizontal

	// Only show icons, no text
	property bool iconsOnly: true

	enum Direction {
		Horizontal,
		Vertical
	}

	implicitWidth: grid.implicitWidth + 2 * padding
	implicitHeight: grid.implicitHeight + 2 * padding

	color: Theme.palette.surface_container
	radius: Config.rounding.large

	GridLayout {
		id: grid
		anchors.centerIn: parent
		rowSpacing: root.itemSpacing
		columnSpacing: root.itemSpacing
		rows: root.direction === NavigationBar.Direction.Horizontal ? children.length : 0
		columns: root.direction === NavigationBar.Direction.Vertical ? 0 : children.length

		Repeater {
			model: root.model

			IconButton {
				id: button

				required property int index
				required property EntryContent modelData

				readonly property int selected: index === root.selectedIndex

				theme: selected ? root.buttonThemeSelected : root.buttonThemeNotSelected
				disabledOpacity: 1
				radius: root.buttonRadius
				spacing: root.contentSpacing
				onClicked: root.selectedIndex = index
				Component.onCompleted: {
					modelData.selected = selected
				}
				onSelectedChanged: {
					modelData.selected = selected
					if (selected) modelData.triggered()
				}

				icon {
					text: button.modelData.icon
					theme: button.selected ? root.iconThemeSelected : root.iconThemeNotSelected
				}
				text {
					visible: !root.iconsOnly
					text: button.modelData.text
					theme: button.selected ? root.textThemeSelected : root.textThemeNotSelected
				}
			}
		}
	}
}
