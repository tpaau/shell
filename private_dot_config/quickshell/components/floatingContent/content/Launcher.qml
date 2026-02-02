pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
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

		StyledTextField {
			id: searchBox

			implicitWidth: layout.implicitWidth
			implicitHeight: Config.appLauncher.entryHeight * 5/6
			Layout.bottomMargin: 2 * list.spacing
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

		component AppEntry: StyledButton {
			id: entry

			required property int index
			required property DesktopEntry modelData

			readonly property int selected: list.currentIndex === index

			implicitWidth: Config.appLauncher.entryWidth
			implicitHeight: Config.appLauncher.entryHeight

			regularColor: list.currentIndex === index ?
				hoveredColor : Theme.palette.surface
			hoveredColor: Theme.palette.surfaceBright
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
					margins: Config.spacing.small
				}
				spacing: Config.spacing.normal

				ClippingRectangle {
					id: iconWrapper
					Layout.preferredWidth: 45
					Layout.preferredHeight: 45
					radius: Config.rounding.small
					color: "transparent"

					Image {
						id: icon
						anchors.fill: parent
						visible: !fallbackIcon.visible
						mipmap: true
						asynchronous: true
						source: Quickshell.iconPath(entry.modelData.icon, true)
					}
					StyledIcon {
						id: fallbackIcon
						anchors {
							fill: parent
							margins: Config.spacing.small / 2
						}
						visible: !icon.source || icon.source == ""
						font.pixelSize: width
						fill: 0
						text: ""
					}
				}

				ColumnLayout {
					implicitWidth: parent.width - parent.spacing - iconWrapper.width
					Layout.alignment: Qt.AlignCenter

					StyledText {
						color: entry.selected || entry.containsMouse ?
							Theme.palette.textIntense : Theme.palette.text
						font.pixelSize: Config.font.size.large
						font.weight: Config.font.weight.heavy
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
							entry.modelData.comment
							: entry.modelData.genericName !== "" ?
							entry.modelData.genericName : "No description"
					}
				}
			}
		}

		StyledListView {
			id: list

			implicitWidth: Config.appLauncher.entryWidth
			implicitHeight: model.length === 0 ? emptyHeight : Math.min(
				Config.appLauncher.entriesShown * Config.appLauncher.entryHeight
				+ (Config.appLauncher.entriesShown - 1) * spacing,
				model.length * Config.appLauncher.entryHeight
				+ (model.length - 1) * spacing
			)
			model: root.apps
			delegate: AppEntry {}
			highlightColor: Theme.palette.background
			spacing: root.radius / 2

			property int emptyHeight: 0

			footer: StyledText {
				visible: list.model.length === 0
				anchors.horizontalCenter: parent.horizontalCenter
				Component.onCompleted: list.emptyHeight = Qt.binding(() => height)
				text: "No match."
			}
		}
	}
}
