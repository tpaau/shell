import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.modules.floatingContent.content.launcher
import qs.config
import qs.utils

ColumnLayout {
	id: root

	required property QtObject wrapper
	required property QtObject launcher

	readonly property int rounding: Config.rounding.normal

	property list<DesktopEntry> apps: []

	spacing: Config.spacing.normal

	RowLayout {
		Layout.fillWidth: true
		spacing: root.spacing / 2

		StyledTextField {
			id: searchBox

			Layout.fillWidth: true
			implicitHeight: Math.floor(Config.appLauncher.entryHeight * 5/6)
			leftPadding: searchIcon.width + 2 * padding
			focus: true
			onFocusChanged: if (!focus) focus = true

			Component.onCompleted: {
				root.apps = AppList.fuzzyQuery(searchBox.text)
				text = Qt.binding(() => root.launcher.searchText)
				forceActiveFocus()
			}

			Keys.onEscapePressed: root.wrapper.close()
			Keys.onUpPressed: {
				list.highlightRangeMode = ListView.ApplyRange
				list.decrementCurrentIndex()
			}
			Keys.onDownPressed: {
				list.highlightRangeMode = ListView.ApplyRange
				list.incrementCurrentIndex()
			}
			onTextChanged: {
				AppList.currentSearch = text
				root.launcher.searchText = text
				root.apps = AppList.fuzzyQuery(text)
			}
			onAccepted: {
				AppList.run(root.apps[list.currentIndex])
				root.wrapper.close()
			}

			Connections {
				target: AppList

				function onPreppedAppsChanged() {
					root.apps = AppList.fuzzyQuery(searchBox.text)
					list.currentIndex = 0
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

		StyledButton {
			implicitWidth: 50
			implicitHeight: 50
			theme: StyledButton.Theme.Dark
			Layout.alignment: Qt.AlignCenter
			onClicked: root.launcher.setUseGrid(true)

			StyledIcon {
				anchors.centerIn: parent
				text: "grid_view"
			}
		}
		StyledButton {
			implicitWidth: 50
			implicitHeight: 50
			Layout.alignment: Qt.AlignCenter
			theme: StyledButton.Theme.Dark
			onClicked: root.launcher.setUseGrid(false)

			StyledIcon {
				anchors.centerIn: parent
				text: "view_list"
			}
		}
	}

	component ListAppEntry: StyledButton {
		id: entry

		required property QtObject wrapper
		required property DesktopEntry desktopEntry
		required property ListView listView
		required property int spacing
		required property int index

		readonly property int padding: 2 * spacing
		readonly property int selected: list.currentIndex === index
		readonly property int currentIndex: list.currentIndex

		implicitWidth: Config.appLauncher.entryWidth
		implicitHeight: content.implicitHeight + 2 * padding

		regularColor: list.currentIndex === index ?
			hoveredColor : Theme.palette.surface
		hoveredColor: Theme.palette.surfaceBright
		pressedColor: Theme.palette.buttonDarkHovered

		onClicked: {
			AppList.run(desktopEntry)
			entry.wrapper.close()
		}

		RowLayout {
			id: content
			anchors.centerIn: parent
			width: parent.width - 2 * entry.padding
			spacing: 2 * entry.spacing

			ClippingRectangle {
				id: iconWrapper
				Layout.preferredWidth: 45
				Layout.preferredHeight: 45
				Layout.alignment: Qt.AlignLeft
				color: "transparent"
				radius: entry.radius - entry.spacing

				Image {
					id: icon
					anchors.fill: parent
					visible: !fallbackIcon.visible
					mipmap: true
					asynchronous: true
					source: Quickshell.iconPath(entry.desktopEntry.icon, true)
				}
				StyledIcon {
					id: fallbackIcon
					anchors.fill: parent
					visible: !icon.source || icon.source == ""
					font.pixelSize: width
					fill: 0
					text: ""
				}
			}
			ColumnLayout {
				id: textLayout
				width: content.width - iconWrapper.width - content.spacing
				spacing: entry.spacing

				StyledText {
					Layout.alignment: Qt.AlignLeft
					Layout.preferredWidth: textLayout.width
					font.pixelSize: Config.font.size.large
					font.weight: Config.font.weight.heavy
					text: entry.desktopEntry.name
				}
				StyledText {
					Layout.alignment: Qt.AlignLeft
					Layout.preferredWidth: textLayout.width
					text: entry.desktopEntry.comment !== "" ?
						entry.desktopEntry.comment
						: entry.desktopEntry.genericName !== "" ?
						entry.desktopEntry.genericName : "No description"
				}
			}
		}
	}

	StyledListView {
		id: list

		property int emptyHeight: 0

		implicitWidth: Config.appLauncher.entryWidth
		implicitHeight: Utils.clamp(childrenRect.height, 0, 400)
		model: root.apps

		delegate: ListAppEntry {
			required property DesktopEntry modelData
			desktopEntry: modelData
			wrapper: root.wrapper
			listView: list
			spacing: list.spacing
			radius: root.rounding
		}
		highlightColor: Theme.palette.background
		spacing: root.spacing / 2

		Component {
			id: footerComp

			StyledText {
				visible: list.model.length === 0
				anchors.horizontalCenter: parent?.horizontalCenter ?? undefined
				Component.onCompleted: list.emptyHeight = Qt.binding(() => height)
				text: "No match."
			}
		}

		footer: list.model.length === 0 ? footerComp : null
	}
}
