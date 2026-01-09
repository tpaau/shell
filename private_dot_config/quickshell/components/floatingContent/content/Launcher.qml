pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.components.floatingContent.content
import qs.config

Item {
	id: root

	// Must be a QtObject due to a circular dependency issue
	required property QtObject wrapper

	readonly property int radius: Config.rounding.normal

	property list<DesktopEntry> apps: []

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	Behavior on implicitHeight {
		M3NumberAnim { data: Anims.current.effects.regular }
	}

	ColumnLayout {
		id: layout
		spacing: root.radius

		StyledTextField {
			id: searchBox

			implicitWidth: layout.implicitWidth
			implicitHeight: Config.appLauncher.entryHeight * 3/4
			Layout.bottomMargin: 2 * list.spacing
			placeholderText: "Search..."
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
					console.warn("Changed!")
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

		component AppEntry: StyledButton {
			id: entry

			required property int index
			required property DesktopEntry modelData

			readonly property int selected: list.currentIndex === index

			implicitWidth: Config.appLauncher.entryWidth
			implicitHeight: Config.appLauncher.entryHeight

			regularColor: "transparent"
			hoveredColor: "transparent"
			pressedColor: Theme.palette.buttonDarkHovered
			radius: root.radius

			onEntered: {
				list.highlightRangeMode = ListView.NoHighlightRange
				list.currentIndex = index
			}

			onClicked: {
				AppList.run(modelData)
				root.wrapper.close()
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

		ListView {
			id: list

			implicitWidth: Config.appLauncher.entryWidth
			implicitHeight: model.length === 0 ? emptyHeight : Math.min(
				Config.appLauncher.entriesShown * Config.appLauncher.entryHeight
				+ (Config.appLauncher.entriesShown - 1) * spacing,
				model.length * Config.appLauncher.entryHeight
				+ (model.length - 1) * spacing
			)
			spacing: Config.spacing.small / 2
			highlightFollowsCurrentItem: false
			clip: true
			preferredHighlightBegin: 0
			preferredHighlightEnd: height
			model: root.apps
			delegate: AppEntry {}

			property int emptyHeight: 0

			footer: StyledText {
				visible: list.model.length === 0
				anchors.horizontalCenter: parent.horizontalCenter
				Component.onCompleted: list.emptyHeight = Qt.binding(() => height)
				text: "No matches found."
			}
			highlight: Rectangle {
				color: Theme.palette.surface
				implicitWidth: list.currentItem?.width ?? 0
				implicitHeight: list.currentItem?.height ?? 0
				y: list.currentItem?.y ?? 0
				radius: root.radius

				Behavior on y {
					M3NumberAnim { data: Anims.current.effects.fast }
				}
			}
		}
	}
}
