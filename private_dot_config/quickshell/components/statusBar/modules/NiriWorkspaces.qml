pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
import qs.services.niri

StyledButton {
	id: root

	readonly property int small: 10
	readonly property int large: 48
	readonly property int widthActive: isHorizontal ? large: small
	readonly property int heightActive: isHorizontal ? small : large
	readonly property int widthInactive: small
	readonly property int heightInactive: small
	readonly property int margin: Config.statusBar.margin

	required property bool isHorizontal

	implicitHeight:
		isHorizontal ? Config.statusBar.moduleSize
		: layout.height + Config.statusBar.moduleSize - layout.width
	implicitWidth:
		isHorizontal ? layout.width + Config.statusBar.moduleSize - layout.height
		: Config.statusBar.moduleSize

	radius: Math.min(width, height) / 2

	regularColor: Theme.palette.surface
	hoveredColor: Theme.palette.surfaceBright
	pressedColor: Theme.palette.buttonDarkDisabled

	onClicked: Niri.toggleOverview()

	GridLayout {
		id: layout
		anchors.centerIn: parent
		rows: 1
		columns: 1
		flow: root.isHorizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

		Repeater {
			model: Niri.workspaces.length
			WorkspaceItem {
				Layout.alignment: Qt.AlignCenter
			}
		}

		component WorkspaceItem: Rectangle {
			id: workspaceItem
			required property int index
			readonly property Workspace workspace: Niri.workspaces[index]
			readonly property bool active: workspace.isFocused

			radius: Math.min(width, height) / 2

			implicitWidth: active ? root.widthActive : root.widthInactive
			implicitHeight: active ? root.heightActive : root.heightInactive

			color: active ? Theme.palette.workspaceFocused
				: workspace.containsWindow ?
				Theme.palette.workspaceUnfocused : Theme.palette.workspaceInactive

			Behavior on implicitWidth {
				enabled: root.isHorizontal
				NumberAnimation {
					duration: Config.animations.durations.workspace
					easing.type: Config.animations.easings.workspace
				}
			}

			Behavior on implicitHeight {
				enabled: !root.isHorizontal
				NumberAnimation {
					duration: Config.animations.durations.workspace
					easing.type: Config.animations.easings.workspace
				}
			}

			Behavior on color {
				ColorAnimation {
					duration: Config.animations.durations.workspace
					easing.type: Config.animations.easings.workspace
				}
			}
		}
	}
}
