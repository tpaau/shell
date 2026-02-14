import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.floatingContent.content.launcher
import qs.widgets
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
				grid.highlightRangeMode = GridView.ApplyRange
				grid.moveCurrentIndexUp()
			}
			Keys.onRightPressed: {
				grid.highlightRangeMode = GridView.ApplyRange
				grid.moveCurrentIndexRight()
			}
			Keys.onDownPressed: {
				grid.highlightRangeMode = ListView.ApplyRange
				grid.moveCurrentIndexDown()
			}
			Keys.onLeftPressed: {
				grid.highlightRangeMode = GridView.ApplyRange
				grid.moveCurrentIndexLeft()
			}
			onTextChanged: {
				AppList.currentSearch = text
				root.launcher.searchText = text
				root.apps = AppList.fuzzyQuery(text)
			}
			onAccepted: {
				AppList.run(root.apps[grid.currentIndex])
				root.wrapper.close()
			}

			Connections {
				target: AppList

				function onPreppedAppsChanged() {
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

	component GridAppEntry: StyledButton {
		id: entry

		required property QtObject wrapper
		required property DesktopEntry desktopEntry
		required property GridView gridView
		required property int spacing
		required property int index

		readonly property int padding: 2 * spacing
		readonly property int selected: grid.currentIndex === index
		readonly property int currentIndex: grid.currentIndex

		implicitWidth: Config.appLauncher.gridCellSize - 2 * spacing
		implicitHeight: Config.appLauncher.gridCellSize - 2 * spacing

		regularColor: grid.currentIndex === index ?
			hoveredColor : Theme.palette.surface
		hoveredColor: Theme.palette.surfaceBright
		pressedColor: Theme.palette.buttonDarkHovered

		onClicked: {
			AppList.run(desktopEntry)
			entry.wrapper.close()
		}

		ColumnLayout {
			id: entryLayout
			spacing: entry.spacing

			anchors {
				fill: parent
				margins: entry.padding
			}

			ClippingRectangle {
				id: iconWrapper
				implicitHeight: entryLayout.height - entryLayout.spacing - appName.height
				implicitWidth: implicitHeight
				Layout.alignment: Qt.AlignCenter
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

			StyledText {
				id: appName
				text: entry.desktopEntry.name
				font.pixelSize: Config.font.size.small
				elide: Text.ElideRight
				horizontalAlignment: Text.AlignHCenter
				Layout.preferredWidth: parent.width
			}
		}
	}

	Item {
		implicitWidth: grid.implicitWidth - root.spacing
		implicitHeight: grid.implicitHeight

		StyledGridView {
			id: grid

			property int emptyHeight: 0

			cellWidth: Config.appLauncher.gridCellSize
			cellHeight: Config.appLauncher.gridCellSize
			implicitWidth: Config.appLauncher.horizontalCellCount * Config.appLauncher.gridCellSize
			implicitHeight: Utils.clamp(childrenRect.height - emptyHeight,
				emptyHeight, 400)
			model: root.apps
			delegate: GridAppEntry {
				required property DesktopEntry modelData
				desktopEntry: modelData
				wrapper: root.wrapper
				gridView: grid
				spacing: root.spacing / 2
				radius: root.rounding
			}
			highlightColor: Theme.palette.background

			Component {
				id: footerComp

				StyledText {
					visible: grid.model.length === 0
					width: grid.width
					horizontalAlignment: Text.AlignHCenter
					text: "No match."
				}
			}

			footer: grid.model.length === 0 ? footerComp : null
		}
	}
}
