pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.enums
import qs.models
import qs.widgets
import qs.theme
import qs.config
import qs.utils

StyledButton {
	id: root

	required property list<DropDownMenuEntry> entries

	property int padding: Config.spacing.small
	property bool vibrantMenu: false

	readonly property int selectedIndex: menu.selectedIndex
	readonly property color primaryColor: Theme.palette.tertiary

	function selectItem(index: int): int {
		if (menu.itemAt(index)) {
			menu.selectedIndex = index
		} else {
			console.warn(`No item at index ${index}`)
			return 1
		}
		return 0
	}

	implicitWidth: 140
	implicitHeight: 40
	color: "transparent"
	contentColor: Theme.palette.on_surface
	radius: Config.rounding.smaller
	enabled: entries.length > 1

	onClicked: menu.open()

	border {
		width: 2
		color: primaryColor
	}

	RowLayout {
		id: row
		anchors {
			fill: parent
			margins: root.padding
		}

		StyledText {
			text: {
				if (root.entries.length === 0) {
					return "No entries"
				} else {
					return entries[menu.selectedIndex]?.name ?? "error"
				}
			}
			Layout.preferredWidth: row.width - collapseIcon.width - row.spacing
			elide: Text.ElideRight
		}

		CollapseIcon {
			id: collapseIcon
			expanded: menu.openedOrOpening
			Layout.alignment: Qt.AlignRight
			Layout.preferredHeight: parent.implicitHeight
		}
	}

	StyledMenu {
		id: menu
		y: root.height
		implicitWidth: root.width
		vibrant: root.vibrantMenu

		property int selectedIndex: 0
		property bool openedOrOpening: false

		onAboutToShow: openedOrOpening = true
		onAboutToHide: openedOrOpening = false

		Instantiator {
			asynchronous: true
			model: root.entries

			onObjectAdded: (index, object) => {
				menu.insertItem(0, object)
			}

			onObjectRemoved: (index, object) => {
				menu.removeItem(object)
			}

			delegate: StyledMenuItem {
				id: menuItem

				required property int index
				required property DropDownMenuEntry modelData

				selected: menu.selectedIndex === index
				onSelectedChanged: {
					if (selected) {
						modelData.selected()
					} else {
						modelData.deselected()
					}
				}
				vibrant: root.vibrantMenu
				text: modelData.name

				onTriggered: root.selectItem(index)
			}
		}
	}
}
