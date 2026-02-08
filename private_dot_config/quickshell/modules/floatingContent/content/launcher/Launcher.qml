pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.modules.floatingContent.content.launcher
import qs.config
import qs.utils

Item {
	id: root

	// Must be a QtObject due to a circular dependency issue
	required property QtObject wrapper

	property bool useGrid: false
	readonly property int radius: Config.rounding.normal

	property list<DesktopEntry> apps: []

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	Behavior on implicitHeight {
		M3NumberAnim {
			data: Anims.current.effects.regular
			duration: 0
			Component.onCompleted: Qt.callLater(() =>
				duration = Qt.binding(() => Anims.current.effects.regular.duration)
			)
		}
	}

	ColumnLayout {
		id: layout
		spacing: root.radius

		RowLayout {
			Layout.fillWidth: true

			StyledTextField {
				id: searchBox

				Layout.fillWidth: true
				implicitHeight: Math.floor(Config.appLauncher.entryHeight * 5/6)
				leftPadding: searchIcon.width + 2 * padding
				focus: true
				onFocusChanged: if (!focus) focus = true

				Component.onCompleted: {
					root.apps = AppList.fuzzyQuery(searchBox.text)
					forceActiveFocus()
				}

				Keys.onEscapePressed: root.wrapper.close()
				Keys.onDownPressed: {
					list.highlightRangeMode = ListView.ApplyRange
					list.incrementCurrentIndex()
				}
				Keys.onUpPressed: {
					list.highlightRangeMode = ListView.ApplyRange
					list.decrementCurrentIndex()
				}
				onTextChanged: {
					AppList.currentSearch = text
					root.apps = AppList.fuzzyQuery(searchBox.text)
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
				onClicked: root.useGrid = true

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
				onClicked: root.useGrid = false

				StyledIcon {
					anchors.centerIn: parent
					text: "view_list"
				}
			}
		}

		StyledListView {
			id: list

			property int emptyHeight: 0

			implicitWidth: Config.appLauncher.entryWidth
			implicitHeight: Utils.clamp(childrenRect.height - emptyHeight,
				emptyHeight, 400)
			model: root.apps
			delegate: AppEntry {
				required property DesktopEntry modelData
				desktopEntry: modelData
				useGrid: root.useGrid
				list: list
				rounding: root.radius
			}
			highlightColor: Theme.palette.background
			spacing: root.radius / 2

			footer: StyledText {
				visible: list.model.length === 0
				anchors.horizontalCenter: parent.horizontalCenter
				Component.onCompleted: list.emptyHeight = Qt.binding(() => height)
				text: "No match."
			}
		}
	}
}
