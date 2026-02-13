pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.modules.floatingContent.content.launcher
import qs.config
import qs.utils

// This code is a mess
Item {
	id: root

	// Must be a QtObject due to a circular dependency issue
	required property Item wrapper

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

	Behavior on implicitWidth {
		M3NumberAnim { data: Anims.current.effects.regular }
	}

	// FadeLoader {
	// 	id: loader
	// 	active: true
	// 	sourceComponent: redRect
	// 	animDur: Anims.current.effects.regular.duration
	// 	easingType: Easing.BezierSpline
	// 	bezierCurve: Anims.current.effects.regular.curve
	//
	// 	Connections {
	// 		target: root
	// 		function onUseGridChanged() {
	// 			if (root.useGrid) {
	// 				loader.setComp(greenRect)
	// 			} else {
	// 				loader.setComp(redRect)
	// 			}
	// 		}
	// 	}
	//
	// 	Component {
	// 		id: redRect
	// 		Rectangle {
	// 			implicitWidth: 100
	// 			implicitHeight: 100
	// 			color: "red"
	// 		}
	// 	}
	//
	// 	Component {
	// 		id: greenRect
	// 		Rectangle {
	// 			implicitWidth: 100
	// 			implicitHeight: 100
	// 			color: "green"
	// 		}
	// 	}
	// }

	ColumnLayout {
		id: layout
		// anchors.centerIn: parent
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
				Keys.onUpPressed: {
					list.highlightRangeMode = ListView.ApplyRange
					grid.highlightRangeMode = GridView.ApplyRange
					list.decrementCurrentIndex()
					grid.moveCurrentIndexUp()
				}
				Keys.onRightPressed: {
					grid.highlightRangeMode = GridView.ApplyRange
					grid.moveCurrentIndexRight()
				}
				Keys.onDownPressed: {
					list.highlightRangeMode = ListView.ApplyRange
					grid.highlightRangeMode = ListView.ApplyRange
					list.incrementCurrentIndex()
					grid.moveCurrentIndexDown()
				}
				Keys.onLeftPressed: {
					grid.highlightRangeMode = GridView.ApplyRange
					grid.moveCurrentIndexLeft()
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

		Item {
			implicitWidth: grid.implicitWidth - Config.spacing.small
			implicitHeight: grid.implicitHeight
			visible: root.useGrid
			clip: true

			StyledGridView {
				id: grid

				property int emptyHeight: 0

				cellWidth: Config.appLauncher.gridCellSize
				cellHeight: Config.appLauncher.gridCellSize
				implicitWidth: Config.appLauncher.horizontalCellCount * Config.appLauncher.gridCellSize
				implicitHeight: Utils.clamp(childrenRect.height - emptyHeight,
					emptyHeight, 400)
				model: root.apps
				delegate: AppEntry {
					required property DesktopEntry modelData
					desktopEntry: modelData
					useGrid: root.useGrid
					list: null
					grid: grid
					rounding: root.radius
					wrapper: root.wrapper
				}
				highlightColor: Theme.palette.background

				footer: StyledText {
					visible: list.model.length === 0
					Component.onCompleted: list.emptyHeight = Qt.binding(() => height)
					text: "No match."
				}
			}
		}

		StyledListView {
			id: list
			visible: !root.useGrid

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
				grid: null
				rounding: root.radius
				wrapper: root.wrapper
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
