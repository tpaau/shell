pragma ComponentBehavior: Bound

import QtQuick
import qs.models
import qs.services.config

Row {
	id: root

	property list<EntryContent> model: []
	property int selectedIndex: 0
	property int padding: Config.spacing.small
	property int contentSpacing: spacing
	property int buttonTheme: StyledButton.Theme.Primary
	property int iconTheme: StyledIcon.Theme.Inverse
	property int textTheme: StyledIcon.Theme.Inverse
	property real notSelectedOpacity: 0.7

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

			theme: root.buttonTheme
			opacity: selected ? 1.0 : root.notSelectedOpacity
			layer.enabled: true
			onClicked: root.selectedIndex = index
			rect {
				topRightRadius: index == root.model.length - 1 || selected ? Math.min(width, height) / 2 : root.spacing
				bottomRightRadius: index == root.model.length - 1 || selected ? Math.min(width, height) / 2 : root.spacing
				bottomLeftRadius: index == 0 || selected ? Math.min(width, height) / 2 : root.spacing
				topLeftRadius: index == 0 || selected ? Math.min(width, height) / 2 : root.spacing
			}

			icon {
				text: button.modelData.icon
				theme: root.iconTheme
			}

			text {
				text: button.modelData.text
				theme: root.textTheme
			}
		}
	}
}
