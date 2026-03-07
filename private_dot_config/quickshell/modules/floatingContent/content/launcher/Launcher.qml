pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.modules.floatingContent.content.launcher
import qs.services.apps
import qs.services.cache
import qs.services.config

Item {
	id: root

	// Must be a QtObject due to a circular dependency issue
	required property Item wrapper

	readonly property int spacing: Config.spacing.normal
	readonly property M3AnimData animData: Anims.current.effects.regular

	property bool useGrid: Cache.launcher.useGrid
	function setUseGrid(useGrid: bool) {
		Cache.launcher.useGrid = useGrid
	}
	property list<DesktopEntry> apps: []

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	function close() { wrapper.close() }

	Behavior on implicitHeight {
		M3NumberAnim {
			data: root.animData
			duration: 0
			Component.onCompleted: Qt.callLater(() =>
				duration = Qt.binding(() => Anims.current.effects.regular.duration)
			)
		}
	}

	ColumnLayout {
		id: layout
		spacing: root.spacing

		RowLayout {
			Layout.fillWidth: true
			spacing: root.spacing / 2

			StyledTextField {
				id: searchBox

				Layout.fillWidth: true
				implicitHeight: Math.floor(Config.appLauncher.entryHeight * 5/6)
				leftPadding: searchIcon.width + 2 * padding

				Component.onCompleted: {
					root.apps = Apps.fuzzyQuery(searchBox.text)
					forceActiveFocus()
				}

				Keys.onEscapePressed: root.wrapper.close()
				Keys.onUpPressed: {
					view.goUp()
				}
				Keys.onRightPressed: {
					view.goRight()
				}
				Keys.onDownPressed: {
					view.goDown()
				}
				Keys.onLeftPressed: {
					view.goLeft()
				}
				onTextChanged: {
					Apps.currentSearch = text
					root.apps = Apps.fuzzyQuery(text)
				}
				onAccepted: {
					Apps.run(root.apps[view.currentIndex])
					root.wrapper.close()
				}

				Connections {
					target: Apps

					function onPreppedAppsChanged() {
						root.apps = Apps.fuzzyQuery(searchBox.text)
						view.setCurrentIndex(0)
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
			NavigationBar {
				iconsOnly: true
				activeIndex: root.useGrid ? 0 : 1
				items: [
					NavigationBarItem {
						icon: "grid_view"
						onActiveChanged: if (active) root.setUseGrid(true)
					},
					NavigationBarItem {
						icon: "view_list"
						onActiveChanged: if (active) root.setUseGrid(false)
					}
				]
			}
		}

		AppView {
			id: view
			useGrid: root.useGrid
			apps: root.apps
			wrapper: root
			animData: root.animData
			Layout.alignment: Qt.AlignCenter
		}
	}
}
