pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config
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

	Grid {
		id: layout
		anchors.centerIn: parent
		rows: root.isHorizontal ? 1 : children.length
		columns: root.isHorizontal ? children.length : 1
		rowSpacing: root.spacing
		columnSpacing: root.spacing

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
