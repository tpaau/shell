pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.I3
import qs.config

RowLayout {
	id: root

	property int widthActive: 48
	property int heightActive: 10
	property int widthInactive: 10
	property int heightInactive: 10

	Repeater {
		readonly property int alwaysActive: 5

		model: {
			let workspaces = I3.workspaces.values
			let len = workspaces[workspaces.length - 1]?.number ?? 0
			let num = workspaces + 1 >= alwaysActive ? len + 1 : alwaysActive
			len > alwaysActive ? len : alwaysActive
		}

		Workspace {
			Layout.alignment: Qt.AlignCenter
		}
	}

	component Workspace: Rectangle {
		required property int index

		property bool active: {
			let focused = I3.focusedWorkspace
			if (focused != null && focused.number - 1 == index) {
				return true
			}
			return false
		}

		radius: Math.min(width, height) / 2

		implicitWidth: active ? root.widthActive : root.widthInactive
		implicitHeight: active ? root.heightActive : root.heightInactive

		color: active ? Theme.pallete.fg.c6 : Theme.pallete.bg.c8

		Behavior on implicitWidth {
			NumberAnimation {
				duration: Appearance.anims.durations.workspace
				easing.type: Appearance.anims.easings.workspace
			}
		}

		Behavior on color {
			ColorAnimation {
				duration: Appearance.anims.durations.workspace
				easing.type: Appearance.anims.easings.workspace
			}
		}
	}
}
