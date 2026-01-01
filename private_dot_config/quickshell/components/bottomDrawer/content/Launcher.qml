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
			forceActiveFocus()
			root.apps = AppList.fuzzyQuery(searchBox.text)
		}
		Keys.onEscapePressed: drawer.close()
		onTextChanged: {
			AppList.currentSearch = text
			root.apps = AppList.fuzzyQuery(searchBox.text)
		}
		onAccepted: {
			let app = root.apps[root.entryIndex]
			if (app) {
				if (app.runInTerminal) {
					let launchStr = `sh -c "${Config.preferences.terminalApp} ${app.execString}"`
					console.warn(launchStr)
					Quickshell.execDetached(launchStr)
				}
				else {
					app.execute()
				}
				drawer.close()
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

	component AppEntry: Rectangle {
		id: entry

		required property int index
		required property DesktopEntry modelData

		readonly property int radiusSmall: Config.rounding.small / 2
		readonly property int radiusLarge: Config.rounding.small

		implicitWidth: Config.appLauncher.entryWidth
		implicitHeight: Config.appLauncher.entryHeight
		color: Theme.palette.surface

		topRightRadius: index === 0 ? radiusLarge : radiusSmall
		topLeftRadius: index === 0 ? radiusLarge : radiusSmall
		bottomRightRadius: index === root.apps.length  - 1 ? radiusLarge : radiusSmall
		bottomLeftRadius: index === root.apps.length  - 1 ? radiusLarge : radiusSmall

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
				source: {
					let icon =  Quickshell
						.iconPath(entry.modelData.icon, "application-x-executable")
					if (icon && icon != "") return icon
					else return Icons.getAppIcon(entry.modelData.name)
				}
			}

			ColumnLayout {
				implicitWidth: parent.width - parent.spacing - image.width
				Layout.alignment: Qt.AlignCenter

				StyledText {
					// color: Theme.palette.textIntense
					// font.weight: Config.font.weight.heavy
					font.pixelSize: Config.font.size.large
					Layout.alignment: Qt.AlignLeft
					Layout.fillWidth: true
					Layout.preferredWidth: parent.width
					elide: Text.ElideRight
					text: entry.modelData.name
				}

				StyledText {
					// color: Theme.palette.textIntense
					// font.weight: Config.font.weight.heavy
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
		implicitHeight: Config.appLauncher.entriesShown * Config.appLauncher.entryHeight
			+ (Config.appLauncher.entriesShown - 1) * layout.spacing

		ColumnLayout {
			id: layout

			Repeater {
				model: root.apps
				AppEntry {}
			}
		}
	}
}
