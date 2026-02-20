pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.services.config
import qs.services.niri

StyledButton {
	id: root

	readonly property int sizeSmall: 10
	readonly property int sizeLarge: 48
	readonly property int widthActive: isHorizontal ? sizeLarge: sizeSmall
	readonly property int heightActive: isHorizontal ? sizeSmall : sizeLarge
	readonly property int widthInactive: sizeSmall
	readonly property int heightInactive: sizeSmall
	readonly property int spacing: Config.spacing.smaller
	readonly property int animDur: Anims.workspaceSwitchDur
	readonly property int animEasing: Easing.Linear

	// This property is required to read the name of the output, and filter the
	// Niri workspaces.
	required property ShellScreen screen
	required property BarPopup popup
	required property bool isHorizontal

	implicitHeight:
		isHorizontal ?Config.statusBar.size - 2 * Config.statusBar.padding 
		: layout.height + Config.statusBar.size - 2 * Config.statusBar.padding - layout.width
	implicitWidth:
		isHorizontal ? layout.width + Config.statusBar.size - 2 * Config.statusBar.padding - layout.height
		: Config.statusBar.size - 2 * Config.statusBar.padding

	radius: Math.min(width, height) / 2

	clip: false

	regularColor: Theme.palette.surface
	hoveredColor: Theme.palette.surfaceBright
	pressedColor: Theme.palette.buttonDarkDisabled

	onClicked: popup.open(workspacesOverview, this)

	Component {
		id: workspacesOverview
		Rectangle {
			color: "red"
			implicitWidth: 100
			implicitHeight: 200
		}
	}

	Grid {
		id: layout
		anchors.centerIn: parent
		rows: root.isHorizontal ? 1 : children.length
		columns: root.isHorizontal ? children.length : 1
		rowSpacing: root.spacing
		columnSpacing: root.spacing
		bottomPadding: root.isHorizontal ? 0 : -rowSpacing
		rightPadding: root.isHorizontal ? -columnSpacing : 0

		// add: Transition {
		// 	M3NumberAnim {
		// 		data: Anims.current.spatial.fast
		// 		properties: "scale"
		// 		from: 0
		// 		to: 1
		// 	}
		// }

		Repeater {
			id: repeater

			model: ScriptModel {
				// You can filter the workspaces based on the `output` variable so
				// only the workspaces from the current monitor are visible.
				values: [...Niri.workspaces.filter(w => w.output === root.screen?.name)]
			}

			WorkspaceItem {
				Layout.alignment: Qt.AlignCenter
			}
		}

		component WorkspaceItem: Rectangle {
			id: workspaceItem
			required property Workspace modelData
			readonly property bool active: modelData.isFocused

			radius: Math.min(width, height) / 2

			implicitWidth: active ? root.widthActive : root.widthInactive
			implicitHeight: active ? root.heightActive : root.heightInactive

			color: active ? Theme.palette.workspaceFocused
				: modelData.windows.length > 0 ?
				Theme.palette.workspaceUnfocused : Theme.palette.workspaceInactive

			Behavior on implicitWidth {
				enabled: root.isHorizontal
				NumberAnimation {
					duration: root.animDur
					easing.type: root.animEasing
				}
			}

			Behavior on implicitHeight {
				enabled: !root.isHorizontal
				NumberAnimation {
					duration: root.animDur
					easing.type: root.animEasing
				}
			}

			Behavior on color {
				ColorAnimation {
					duration: root.animDur
					easing.type: root.animEasing
				}
			}
		}
	}
}
