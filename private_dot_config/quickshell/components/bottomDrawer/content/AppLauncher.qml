pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

ColumnLayout {
	id: root

	StyledTextField {
		id: searchBox

		implicitWidth: root.implicitWidth
		implicitHeight: Config.appLauncher.entryHeight * 0.67
		Component.onCompleted: forceActiveFocus()
		Layout.bottomMargin: 2 * layout.spacing
		placeholderText: "Search..."
		leftPadding: searchIcon.width + 2 * padding

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

	StyledScrollView {
		id: scroll

		implicitWidth: Config.appLauncher.entryWidth
		implicitHeight: Config.appLauncher.entriesShown * Config.appLauncher.entryHeight
			+ (Config.appLauncher.entriesShown - 1) * layout.spacing

		ColumnLayout {
			id: layout

			Repeater {
				model: 2 * Config.appLauncher.entriesShown

				Rectangle {
					implicitWidth: scroll.width
					implicitHeight: Config.appLauncher.entryHeight
					color: "red"
				}
			}
		}
	}
}
