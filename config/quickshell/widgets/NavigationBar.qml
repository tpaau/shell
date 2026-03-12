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

			IconAndTextButton {
				id: button

				required property int index
				required property EntryContent modelData

				readonly property int selected: index === root.selectedIndex

				theme: selected ? root.buttonThemeSelected : root.buttonThemeNotSelected
				radius: root.buttonRadius
				spacing: root.contentSpacing
				onClicked: root.selectedIndex = index
				style: root.iconsOnly ? IconAndTextButton.Icon
					: IconAndTextButton.IconAndText
				Component.onCompleted: {
					modelData.selected = selected
				}
				onSelectedChanged: {
					modelData.selected = selected
					if (selected) modelData.triggered()
				}

				icon {
					text: button.modelData.icon
					color: button.contentColor
					fill: button.selected ? 1.0 : 0.0
				}
				text {
					visible: !root.iconsOnly
					color: button.contentColor
					text: button.modelData.text
				}
			}
		}
	}
}
