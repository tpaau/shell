pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.utils
import qs.services.apps
import qs.services.config
import qs.services.config.theme

Item {
	id: root
	
	required property bool useGrid
	required property list<DesktopEntry> apps
	required property QtObject wrapper
	required property M3AnimData animData

	readonly property int rounding: Config.rounding.normal
	readonly property int spacing: Config.spacing.normal
	readonly property int currentIndex: useGrid ?
		grid?.currentIndex ?? 0 : list?.currentIndex ?? 0
	readonly property int contentHeight: 400
	readonly property int favButtonSize: 30

	property StyledListView list: null
	property StyledGridView grid: null

	implicitWidth: root.useGrid ? gridWrapper.implicitWidth
		: listLoader.implicitWidth ?? 0
	implicitHeight: root.useGrid ? gridWrapper.implicitHeight : listLoader.implicitHeight ?? 0

	function setCurrentIndex(index: int) {
		if (useGrid) grid.currentIndex = index
		else if (list) list.currentIndex = index
	}
	function goUp() {
		if (list) list.highlightRangeMode = ListView.ApplyRange
		list?.decrementCurrentIndex()
		if (grid) grid.highlightRangeMode = GridView.ApplyRange
		grid?.moveCurrentIndexUp()
	}
	function goRight() {
		if (grid) grid.highlightRangeMode = GridView.ApplyRange
		grid?.moveCurrentIndexRight()
	}
	function goDown() {
		if (list) list.highlightRangeMode = ListView.ApplyRange
		list?.incrementCurrentIndex()
		if (grid) grid.highlightRangeMode = ListView.ApplyRange
		grid?.moveCurrentIndexDown()
	}
	function goLeft() {
		if (grid) grid.highlightRangeMode = GridView.ApplyRange
		grid?.moveCurrentIndexLeft()
	}

	component Anim: M3NumberAnim {
		data: root.animData
		duration: root.animData.duration / 2
		properties: "opacity"
	}

	component FavButton: StyledButton {
		id: favButton

		required property AppMeta metadata
		readonly property bool favourite: favButton.metadata?.favourite ?? false

		implicitWidth: root.favButtonSize
		implicitHeight: root.favButtonSize
		radius: root.favButtonSize / 4
		regularColor: "#00000000"
		hoveredColor: "#00000000"
		pressedColor: "#00000000"

		onClicked: {
			if (metadata) {
				metadata.favourite = !metadata.favourite
				Apps.saveMetaState()
			}
		}

		StyledIcon {
			id: favIcon
			anchors.fill: parent
			font.pixelSize: Math.min(width, height)
			fill: favButton.favourite ? 1 : 0
			theme: favButton.favourite || favButton.containsMouse ? StyledIcon.Theme.Regular : StyledIcon.Theme.RegularDim
			font.weight: favButton.containsMouse ? Config.font.weight.heavy : Config.font.weight.light
			text: "star"

			Behavior on font.weight { M3NumberAnim { data: root.animData } }
		}
	}

	Behavior on implicitWidth { M3NumberAnim { data: root.animData } }

	Loader {
		id: listLoader
		layer.enabled: true
		opacity: root.useGrid ? -1 : 1
		active: opacity > 0

		Behavior on opacity { Anim { } }

		sourceComponent: StyledListView {
			id: list
			anchors.horizontalCenter: parent.horizontalCenter
			Component.onCompleted: root.list = this

			property int emptyHeight: 0

			implicitWidth: Config.appLauncher.horizontalCellCount * Config.appLauncher.gridCellSize - root.spacing
			implicitHeight: Utils.clamp(childrenRect.height, 0, root.contentHeight)
			model: root.apps

			delegate: StyledButton {
				id: listEntry

				required property DesktopEntry modelData
				required property int index

				readonly property int spacing: root.spacing / 2
				readonly property int padding: 2 * listEntry.spacing
				readonly property int selected: list.currentIndex === index
				readonly property int currentIndex: list.currentIndex
				readonly property AppMeta metadata: Apps.appMetaList.find(a => a.index == modelData.id) ?? null

				implicitWidth: list.width
				implicitHeight: content.implicitHeight + 2 * padding

				theme: StyledButton.Theme.OnSurfaceContainer
				regularColor: list.currentIndex === index ?
					Utils.blendColor(Theme.palette.surface_container, pressedColor)
					: Theme.palette.surface_container_low

				onClicked: {
					Apps.run(modelData)
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
						implicitWidth: content.width - iconWrapper.width - content.spacing
						spacing: listEntry.spacing

						RowLayout {
							id: headerLayout
							spacing: listEntry.spacing
							implicitWidth: parent.implicitWidth

							StyledText {
								id: headerText
								Layout.alignment: Qt.AlignLeft
								Layout.preferredWidth: headerLayout.implicitWidth - favButton.implicitWidth - headerLayout.spacing
								elide: Text.ElideRight
								font.pixelSize: Config.font.size.large
								font.weight: Config.font.weight.heavy
								text: listEntry.modelData.name
							}

							FavButton {
								id: favButton
								metadata: listEntry.metadata
							}
						}
						StyledText {
							Layout.alignment: Qt.AlignLeft
							Layout.preferredWidth: textLayout.implicitWidth
							elide: Text.ElideRight
							text: listEntry.modelData.comment !== "" ?
								listEntry.modelData.comment
								: listEntry.modelData.genericName !== "" ?
								listEntry.modelData.genericName : "No description"
						}
					}
				}
			}

			highlightColor: Theme.palette.surface
			spacing: root.rounding / 2

			Component {
				id: listFooterComp

				StyledText {
					anchors.horizontalCenter: parent?.horizontalCenter ?? undefined
					Component.onCompleted: list.emptyHeight = Qt.binding(() => height)
					text: "No match."
				}
			}

			footer: list.model.length === 0 ? listFooterComp : null
		}
	}

	Item {
		id: gridWrapper
		anchors.horizontalCenter: parent.horizontalCenter
		implicitWidth: gridLoader.implicitWidth - root.spacing
		implicitHeight: root.apps.length === 0 ? gridLoader.implicitHeight : gridLoader.implicitHeight - root.spacing
		clip: true

		Loader {
			id: gridLoader
			layer.enabled: true
			opacity: root.useGrid ? 1 : -1
			active: opacity > 0

			Behavior on opacity { Anim { } }

			sourceComponent: StyledGridView {
				id: grid

				Component.onCompleted: root.grid = this

				property int emptyHeight: 0

				cellWidth: Config.appLauncher.gridCellSize
				cellHeight: Config.appLauncher.gridCellSize
				implicitWidth: Config.appLauncher.horizontalCellCount * Config.appLauncher.gridCellSize
				implicitHeight: Utils.clamp(childrenRect.height - emptyHeight,
					emptyHeight, root.contentHeight + root.spacing)
				model: root.apps

				delegate: StyledButton {
					id: gridEntry

					required property DesktopEntry modelData
					required property int index

					readonly property int spacing: root.spacing / 2
					readonly property int padding: 2 * spacing
					readonly property int selected: grid.currentIndex === index
					readonly property int currentIndex: grid.currentIndex
					readonly property AppMeta metadata: Apps.appMetaList.find(a => a.index == modelData.id) ?? null

					implicitWidth: Config.appLauncher.gridCellSize - 2 * spacing
					implicitHeight: Config.appLauncher.gridCellSize - 2 * spacing

					radius: root.rounding
					theme: StyledButton.Theme.OnSurfaceContainer
					regularColor: grid.currentIndex === index ?
						Utils.blendColor(Theme.palette.surface_container, pressedColor)
						: Theme.palette.surface_container_low

					onClicked: {
						Apps.run(modelData)
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
					FavButton {
						anchors {
							top: parent.top
							right: parent.right
							margins: gridEntry.padding / 2
						}
						metadata: gridEntry.metadata
						opacity: gridEntry.containsMouse ? 1 : 0

						Behavior on opacity { M3NumberAnim { data: root.animData } }
					}
				}
				highlightColor: Theme.palette.surface

				Component {
					id: gridFooterComp

					StyledText {
						width: grid.width
						height: grid.model.length === 0 ? implicitHeight : 0
						horizontalAlignment: Text.AlignHCenter
						text: "No match."
					}
				}

				footer: grid.model.length === 0 ? gridFooterComp : null
			}
		}
	}
}
