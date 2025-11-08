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

	readonly property color colorFocused: Theme.pallete.fg.c8
	readonly property color colorUnfocused: Theme.pallete.fg.c1
	readonly property color colorInactive: Theme.pallete.bg.c6

	required property bool isHorizontal

	implicitHeight:
		isHorizontal ? Config.statusBar.moduleSize
		: layout.height + Config.statusBar.moduleSize - layout.width
	implicitWidth:
		isHorizontal ? layout.width + Config.statusBar.moduleSize - layout.height
		: Config.statusBar.moduleSize

	radius: Math.min(width, height) / 2

	regularColor: Theme.palette.surfaceRegular
	hoveredColor: Theme.palette.surfaceBright
	pressedColor: Theme.palette.buttonDisabled

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

			color: active ? root.colorFocused
			: workspace.containsWindow ? root.colorUnfocused : root.colorInactive

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
