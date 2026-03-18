pragma ComponentBehavior: Bound

import QtQuick
import qs.enums
import qs.models
import qs.widgets
import qs.config

Row {
	id: root

	property list<EntryContent> model: []
	property int selectedIndex: 0
	property int padding: Config.spacing.small
	property int contentSpacing: spacing
	property int theme: Accent.Primary
	property bool enabled: true

	readonly property int activeTheme: switch (theme) {
		case Accent.Primary:
			return StyledButton.Primary
		case Accent.Secondary:
			return StyledButton.Secondary
		case Accent.Tertiary:
			return StyledButton.Tertiary
	}
	readonly property int inactiveTheme: switch (theme) {
		case Accent.Primary:
			return StyledButton.PrimaryInactive
		case Accent.Secondary:
			return StyledButton.SecondaryInactive
		case Accent.Tertiary:
			return StyledButton.TertiaryInactive
	}

	spacing: Config.spacing.smaller

	Repeater {
		id: repeater
		model: root.model

		IconAndTextButton {
			id: button

			required property int index
			required property EntryContent modelData

			readonly property bool selected: index == root.selectedIndex
			onSelectedChanged: {
				modelData.selected = selected
				if (selected) modelData.triggered()
			}

			enabled: root.enabled
			theme: selected ? root.activeTheme : root.inactiveTheme
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
