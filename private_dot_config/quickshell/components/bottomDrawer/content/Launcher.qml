pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.components.bottomDrawer.content
import qs.config
import qs.utils

ColumnLayout {
	id: root

	// Must be a QtObject due to a circular dependency issue
	required property QtObject drawer

	property list<DesktopEntry> apps: []
	onAppsChanged: entryIndex = Utils.clamp(entryIndex, 0, apps.length - 1)
	onEntryIndexChanged: entryIndex = Utils.clamp(entryIndex, 0, apps.length - 1)
	property int entryIndex: 0

	StyledTextField {
		id: searchBox

		implicitWidth: root.implicitWidth
		implicitHeight: Config.appLauncher.entryHeight * 2/3
		Layout.bottomMargin: 2 * layout.spacing
		placeholderText: "Search..."
		leftPadding: searchIcon.width + 2 * padding
		focus: true

		Component.onCompleted: {
			root.apps = AppList.fuzzyQuery(searchBox.text)
			forceActiveFocus()
		}

		Keys.onEscapePressed: drawer.close()
		Keys.onDownPressed: root.entryIndex += 1
		Keys.onUpPressed: root.entryIndex -= 1
		onTextChanged: {
			AppList.currentSearch = text
			root.apps = AppList.fuzzyQuery(searchBox.text)
		}
		onAccepted: {
			AppList.run(root.apps[root.entryIndex])
			drawer.close()
		}

		Connections {
			target: AppList

			function onPreppedAppsChanged() {
				console.warn("Changed!")
				root.apps = AppList.fuzzyQuery(searchBox.text)
			}
		}

		StyledIcon {
			id: searchIcon

			anchors {
				verticalCenter: parent.verticalCenter
				left: parent.left
				leftMargin: searchBox.padding
			}
			text: ""
		}
	}

	component AppEntry: StyledButton {
		id: entry

		required property int index
		required property DesktopEntry modelData

		readonly property int radiusSmall: Config.rounding.small / 2
		readonly property int radiusLarge: Config.rounding.small
		readonly property int selected: root.entryIndex === index

		implicitWidth: Config.appLauncher.entryWidth
		implicitHeight: Config.appLauncher.entryHeight

		regularColor: selected ? hoveredColor : Theme.palette.surface
		hoveredColor: Theme.palette.buttonDarkRegular
		pressedColor: Theme.palette.buttonDarkHovered

		rect.topRightRadius: index === 0 ? radiusLarge : radiusSmall
		rect.topLeftRadius: index === 0 ? radiusLarge : radiusSmall
		rect.bottomRightRadius: index === root.apps.length  - 1 ?
			radiusLarge : radiusSmall
		rect.bottomLeftRadius: index === root.apps.length  - 1 ?
			radiusLarge : radiusSmall

		onClicked: {
			AppList.run(modelData)
			drawer.close()
		}

		RowLayout {
			anchors {
				fill: parent
				margins: Config.spacing.normal
			}
			spacing: Config.spacing.normal

			Image {
				id: image
				Layout.preferredWidth: 50
				Layout.preferredHeight: 50
				mipmap: true
				asynchronous: true
				source: Quickshell.iconPath(entry.modelData.icon, "application-x-executable")
			}

			ColumnLayout {
				implicitWidth: parent.width - parent.spacing - image.width
				Layout.alignment: Qt.AlignCenter

				StyledText {
					color: entry.selected || entry.containsMouse ?
						Theme.palette.textIntense : Theme.palette.text
					font.pixelSize: Config.font.size.large
					Layout.alignment: Qt.AlignLeft
					Layout.fillWidth: true
					Layout.preferredWidth: parent.width
					elide: Text.ElideRight
					text: entry.modelData.name
				}

				StyledText {
					color: entry.selected || entry.containsMouse ?
						Theme.palette.textIntense : Theme.palette.text
					Layout.alignment: Qt.AlignLeft
					Layout.fillWidth: true
					Layout.preferredWidth: parent.width
					elide: Text.ElideRight
					text: entry.modelData.comment && entry.modelData.comment !== "" ?
						entry.modelData.comment : "No description"
				}
			}
		}
	}

	StyledScrollView {
		id: scroll

		implicitWidth: Config.appLauncher.entryWidth
		implicitHeight: Math.min(
			Config.appLauncher.entriesShown * Config.appLauncher.entryHeight
			+ (Config.appLauncher.entriesShown - 1) * layout.spacing,
			layout.height)

		ColumnLayout {
			id: layout

			Repeater {
				model: root.apps
				AppEntry {}
			}

			StyledText {
				visible: root.apps.length === 0
				Layout.preferredWidth: scroll.width
				horizontalAlignment: Text.AlignHCenter
				text: "No matches found."
			}
		}
	}
}
