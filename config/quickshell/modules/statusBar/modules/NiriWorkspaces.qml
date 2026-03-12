pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.utils
import qs.services.niri
import qs.services.config
import qs.services.config.theme

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
	readonly property color colorActive: Theme.palette.primary
	readonly property color colorInactive: Utils.blendColor(colorActive, colorDisabled)
	readonly property color colorDisabled: Utils.blendColor(colorActive, Theme.palette.on_primary)

	// This property is required to read the name of the output, and filter the
	// Niri workspaces.
	required property ShellScreen screen
	required property bool isHorizontal

	implicitHeight:
		isHorizontal ?Config.statusBar.size - 2 * Config.statusBar.padding 
		: layout.height + Config.statusBar.size - 2 * Config.statusBar.padding - layout.width
	implicitWidth:
		isHorizontal ? layout.width + Config.statusBar.size - 2 * Config.statusBar.padding - layout.height
		: Config.statusBar.size - 2 * Config.statusBar.padding

	clip: false
	radius: Math.min(width, height) / 2
	theme: StyledButton.Theme.OnSurfaceContainer

	onClicked: Niri.toggleOverview()

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

			color: active ? root.colorActive
				: modelData.windows.length > 0 ?
				root.colorInactive : root.colorDisabled

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
