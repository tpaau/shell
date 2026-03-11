pragma ComponentBehavior: Bound

import QtQuick
import qs.models
import qs.services.config
import qs.services.config.theme

Row {
	id: root

	property list<EntryContent> model: []
	property int selectedIndex: 0
	property int padding: Config.spacing.small
	property int contentSpacing: spacing
	property int theme: ButtonGroup.Theme.Primary

	enum Theme {
		Primary,
		Secondary,
		Tertiary
	}

	readonly property color activeColor: switch (theme) {
		case ButtonGroup.Theme.Primary:
			return Theme.palette.primary
		case ButtonGroup.Theme.Secondary:
			return Theme.palette.secondary
		case ButtonGroup.Theme.Tertiary:
			return Theme.palette.tertiary
	}
	readonly property color inactiveColor: switch (theme) {
		case ButtonGroup.Theme.Primary:
			return Theme.palette.primary_container
		case ButtonGroup.Theme.Secondary:
			return Theme.palette.secondary_container
		case ButtonGroup.Theme.Tertiary:
			return Theme.palette.tertiary_container
	}
	readonly property color contentColor: switch (theme) {
		case ButtonGroup.Theme.Primary:
			return Theme.palette.on_primary
		case ButtonGroup.Theme.Secondary:
			return Theme.palette.on_secondary
		case ButtonGroup.Theme.Tertiary:
			return Theme.palette.on_tertiary
	}

	spacing: Config.spacing.smaller

	Repeater {
		id: repeater
		model: root.model

		IconButton {
			id: button

			required property int index
			required property EntryContent modelData

			readonly property bool selected: index == root.selectedIndex
			onSelectedChanged: {
				modelData.selected = selected
				if (selected) modelData.triggered()
			}

			color: selected ? root.activeColor : root.inactiveColor
			contentColor: selected ? root.contentColor : root.activeColor
			layer.enabled: true
			onClicked: root.selectedIndex = index
			topRightRadius: index == root.model.length - 1 || selected ? Math.min(width, height) / 2 : root.spacing
			bottomRightRadius: index == root.model.length - 1 || selected ? Math.min(width, height) / 2 : root.spacing
			bottomLeftRadius: index == 0 || selected ? Math.min(width, height) / 2 : root.spacing
			topLeftRadius: index == 0 || selected ? Math.min(width, height) / 2 : root.spacing

			icon {
				text: button.modelData.icon
				fill: button.selected ? 1.0 : 0.0
			}

			text.text: button.modelData.text
		}
	}
}
