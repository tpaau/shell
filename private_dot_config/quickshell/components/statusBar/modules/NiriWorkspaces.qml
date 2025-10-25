pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services.niri

RowLayout {
	id: root

	readonly property int widthActive: 48
	readonly property int heightActive: 10
	readonly property int widthInactive: 10
	readonly property int heightInactive: 10

	readonly property color colorFocused: Theme.pallete.fg.c6
	readonly property color colorUnfocused: Theme.pallete.bg.c8
	readonly property color colorInactive: Theme.pallete.bg.c4

	Repeater {
		model: Math.max(0, Niri.workspaces.length - 1)

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
