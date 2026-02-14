import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.utils

Item {
	id: root
	
	required property bool useGrid
	required property list<DesktopEntry> apps
	required property QtObject wrapper
	required property M3AnimData animData

	readonly property int rounding: Config.rounding.normal
	readonly property int spacing: Config.spacing.normal
	readonly property int currentIndex: useGrid ? grid.currentIndex : list.currentIndex

	implicitWidth: root.useGrid ? grid.implicitWidth - root.spacing
		: list.implicitWidth
	implicitHeight: root.useGrid ? grid.implicitHeight : list.implicitHeight

	property bool firstChange: true
	onUseGridChanged: {
		list.currentIndex = 0
		grid.currentIndex = 0
		if (firstChange) {
			if (useGrid) list.opacity = 0
			else grid.opacity = 0
			firstChange = false
		} else {
			if (useGrid) listCloseAnim.restart()
			else gridCloseAnim.restart()
		}
	}

	function setCurrentIndex(index: int) {
		if (useGrid) grid.currentIndex = index
		else list.currentIndex = index
	}
	function goUp() {
		list.highlightRangeMode = ListView.ApplyRange
		list.decrementCurrentIndex()
		grid.highlightRangeMode = GridView.ApplyRange
		grid.moveCurrentIndexUp()
	}
	function goRight() {
		grid.highlightRangeMode = GridView.ApplyRange
		grid.moveCurrentIndexRight()
	}
	function goDown() {
		list.highlightRangeMode = ListView.ApplyRange
		list.incrementCurrentIndex()
		grid.highlightRangeMode = ListView.ApplyRange
		grid.moveCurrentIndexDown()
	}
	function goLeft() {
		grid.highlightRangeMode = GridView.ApplyRange
		grid.moveCurrentIndexLeft()
	}

	component Anim: M3NumberAnim {
		data: root.animData
		duration: root.animData.duration / 2
		properties: "opacity"
	}

	Behavior on implicitWidth { M3NumberAnim { data: root.animData } }

	StyledListView {
		id: list
		layer.enabled: true
		visible: opacity > 0

		Anim {
			id: listOpenAnim
			target: list
			from: 0
			to: 1
		}
		Anim {
			id: listCloseAnim
			target: list
			from: 1
			to: 0
			onFinished: gridOpenAnim.restart()
		}

		property int emptyHeight: 0

		implicitWidth: Config.appLauncher.entryWidth
		implicitHeight: Utils.clamp(childrenRect.height, 0, 400)
		model: root.apps

		delegate: StyledButton {
			id: listEntry

			required property DesktopEntry modelData
			required property int index

			readonly property int spacing: root.spacing / 2
			readonly property int padding: 2 * listEntry.spacing
			readonly property int selected: list.currentIndex === index
			readonly property int currentIndex: list.currentIndex

			implicitWidth: Config.appLauncher.entryWidth
			implicitHeight: content.implicitHeight + 2 * padding

			regularColor: list.currentIndex === index ?
				hoveredColor : Theme.palette.surface
			hoveredColor: Theme.palette.surfaceBright
			pressedColor: Theme.palette.buttonDarkHovered

			onClicked: {
				AppList.run(modelData)
				root.wrapper.close()
			}

			RowLayout {
				id: content
				anchors.centerIn: parent
				width: parent.width - 2 * listEntry.padding
				spacing: 2 * listEntry.spacing

				ClippingRectangle {
					id: iconWrapper
					Layout.preferredWidth: 45
					Layout.preferredHeight: 45
					Layout.alignment: Qt.AlignLeft
					color: "transparent"
					radius: listEntry.radius - listEntry.spacing

					Image {
						id: icon
						anchors.fill: parent
						visible: !fallbackIcon.visible
						mipmap: true
						asynchronous: true
						source: Quickshell.iconPath(listEntry.modelData.icon, true)
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
					spacing: listEntry.spacing

					StyledText {
						Layout.alignment: Qt.AlignLeft
						Layout.preferredWidth: textLayout.width
						font.pixelSize: Config.font.size.large
						font.weight: Config.font.weight.heavy
						text: listEntry.modelData.name
					}
					StyledText {
						Layout.alignment: Qt.AlignLeft
						Layout.preferredWidth: textLayout.width
						text: listEntry.modelData.comment !== "" ?
							listEntry.modelData.comment
							: listEntry.modelData.genericName !== "" ?
							listEntry.modelData.genericName : "No description"
					}
				}
			}
		}

		highlightColor: Theme.palette.background
		spacing: root.rounding / 2

		Component {
			id: listFooterComp

			StyledText {
				visible: list.model.length === 0
				anchors.horizontalCenter: parent?.horizontalCenter ?? undefined
				Component.onCompleted: list.emptyHeight = Qt.binding(() => height)
				text: "No match."
			}
		}

		footer: list.model.length === 0 ? listFooterComp : null
	}

	StyledGridView {
		id: grid
		layer.enabled: true
		visible: opacity > 0

		Anim {
			id: gridOpenAnim
			target: grid
			from: 0
			to: 1
		}
		Anim {
			id: gridCloseAnim
			target: grid
			from: 1
			to: 0
			onFinished: listOpenAnim.restart()
		}

		property int emptyHeight: 0

		cellWidth: Config.appLauncher.gridCellSize
		cellHeight: Config.appLauncher.gridCellSize
		implicitWidth: Config.appLauncher.horizontalCellCount * Config.appLauncher.gridCellSize
		implicitHeight: Utils.clamp(childrenRect.height - emptyHeight,
			emptyHeight, 400)
		model: root.apps

		delegate: StyledButton {
			id: gridEntry

			required property DesktopEntry modelData
			required property int index

			readonly property int spacing: root.spacing / 2
			readonly property int padding: 2 * spacing
			readonly property int selected: grid.currentIndex === index
			readonly property int currentIndex: grid.currentIndex

			implicitWidth: Config.appLauncher.gridCellSize - 2 * spacing
			implicitHeight: Config.appLauncher.gridCellSize - 2 * spacing

			radius: root.rounding
			regularColor: grid.currentIndex === index ?
				hoveredColor : Theme.palette.surface
			hoveredColor: Theme.palette.surfaceBright
			pressedColor: Theme.palette.buttonDarkHovered

			onClicked: {
				AppList.run(modelData)
				root.wrapper.close()
			}

			ColumnLayout {
				id: entryLayout
				spacing: gridEntry.spacing

				anchors {
					fill: parent
					margins: gridEntry.padding
				}

				ClippingRectangle {
					id: iconWrapper
					implicitHeight: entryLayout.height - entryLayout.spacing - appName.height
					implicitWidth: implicitHeight
					Layout.alignment: Qt.AlignCenter
					color: "transparent"
					radius: gridEntry.radius - gridEntry.spacing

					Image {
						id: icon
						anchors.fill: parent
						visible: !fallbackIcon.visible
						mipmap: true
						asynchronous: true
						source: Quickshell.iconPath(gridEntry.modelData.icon, true)
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
					text: gridEntry.modelData.name
					font.pixelSize: Config.font.size.small
					elide: Text.ElideRight
					horizontalAlignment: Text.AlignHCenter
					Layout.preferredWidth: parent.width
				}
			}
		}
		highlightColor: Theme.palette.background

		Component {
			id: gridFooterComp

			StyledText {
				visible: grid.model.length === 0
				width: grid.width
				horizontalAlignment: Text.AlignHCenter
				text: "No match."
			}
		}

		footer: grid.model.length === 0 ? gridFooterComp : null
	}
}
