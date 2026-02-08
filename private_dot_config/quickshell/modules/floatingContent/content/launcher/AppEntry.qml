pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.floatingContent.content.launcher
import qs.widgets
import qs.config

StyledButton {
	id: root

	required property int index
	required property DesktopEntry desktopEntry
	required property bool useGrid
	required property ListView list
	required property int rounding

	readonly property int selected: list.currentIndex === index
	readonly property int spacing: Config.spacing.small

	implicitWidth: root.useGrid ?
		implicitHeight : Config.appLauncher.entryWidth
	implicitHeight: content.implicitHeight + 2 * spacing

	regularColor: list.currentIndex === index ?
		hoveredColor : Theme.palette.surface
	hoveredColor: Theme.palette.surfaceBright
	pressedColor: Theme.palette.buttonDarkHovered
	radius: rounding

	onEntered: {
		list.highlightRangeMode = ListView.NoHighlightRange
		list.currentIndex = index
	}

	onClicked: {
		AppList.run(desktopEntry)
		root.wrapper.close()
	}

	RowLayout {
		id: content
		anchors.centerIn: parent
		implicitWidth: parent.width - 2 * parent.spacing
		spacing: Config.spacing.normal

		ColumnLayout {
			Layout.alignment: Qt.AlignCenter

			ClippingRectangle {
				id: iconWrapper
				Layout.preferredWidth: root.useGrid ? 70 : 45
				Layout.preferredHeight: root.useGrid ? 70 : 45
				Layout.alignment: Qt.AlignCenter
				color: "transparent"
				radius: root.radius - root.spacing

				Image {
					id: icon
					anchors.fill: parent
					visible: !fallbackIcon.visible
					mipmap: true
					asynchronous: true
					source: Quickshell.iconPath(root.desktopEntry.icon, true)
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
				visible: root.useGrid
				Layout.preferredWidth: content.width
				color: root.selected || root.containsMouse ?
					Theme.palette.textIntense : Theme.palette.text
				font.pixelSize: Config.font.size.small
				text: root.desktopEntry.name
				horizontalAlignment: Text.AlignHCenter
				elide: Text.ElideRight
			}
		}

		Loader {
			active: !root.useGrid
			visible: !root.useGrid
			sourceComponent: ColumnLayout {
				implicitWidth: root.width
					- 2 * Config.spacing.small
					- content.spacing
					- iconWrapper.width

				StyledText {
					color: root.selected || root.containsMouse ?
						Theme.palette.textIntense : Theme.palette.text
					font.pixelSize: Config.font.size.large
					font.weight: Config.font.weight.heavy
					Layout.alignment: Qt.AlignLeft
					Layout.preferredWidth: parent.width
					elide: Text.ElideRight
					text: root.desktopEntry.name
				}

				StyledText {
					color: root.selected || root.containsMouse ?
						Theme.palette.textIntense : Theme.palette.text
					Layout.alignment: Qt.AlignLeft
					Layout.preferredWidth: parent.width
					elide: Text.ElideRight
					text: root.desktopEntry.comment && root.desktopEntry.comment !== "" ?
						root.desktopEntry.comment
						: root.desktopEntry.genericName !== "" ?
						root.desktopEntry.genericName : "No description"
				}
			}
		}
	}
}
