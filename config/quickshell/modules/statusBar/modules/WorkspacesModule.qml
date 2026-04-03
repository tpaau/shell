pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.modules.statusBar.modules
import qs.theme
import qs.config
import qs.utils
import qs.services.niri

ModuleGroup {
	id: root

	GridLayout {
		rows: 1
		columns: 1
		flow: root.isHorizontal ? GridLayout.TopToBottom
			: GridLayout.LeftToRight

		Repeater {
			model: Niri.workspaces

			StyledButton {
				id: workspaceButton

				required property Workspace modelData

				implicitWidth: Math.max(root.isHorizontal ?
					grid.implicitWidth + 2 * Config.statusBar.padding
					: Config.statusBar.size - 4 * Config.statusBar.padding,
					Config.statusBar.size - 4 * Config.statusBar.padding)
				implicitHeight: Math.max(root.isHorizontal ?
					Config.statusBar.size - 4 * Config.statusBar.padding
					: grid.implicitHeight + 2 * Config.statusBar.padding,
					Config.statusBar.size - 4 * Config.statusBar.padding)
				radius: (Config.statusBar.size - 2 * Config.statusBar.padding) / 2
				theme: StyledButton.OnSurfaceContainer
				color: modelData?.windows.length === 0 ?? false ?
					Theme.palette.surface_container
					: Theme.palette.surface_container_highest

				onClicked: modelData?.focus()

				Rectangle {
					visible: workspaceButton.modelData?.windows.length === 0 ?? false
					anchors.centerIn: parent
					implicitWidth: 6
					implicitHeight: 6
					radius: 3
					color: Qt.alpha(Theme.palette.on_surface, 0.5)
				}

				GridLayout {
					id: grid
					anchors.centerIn: parent
					rows: 1
					columns: 1
					rowSpacing: Config.spacing.small
					columnSpacing: Config.spacing.small
					flow: root.isHorizontal ? GridLayout.TopToBottom
						: GridLayout.LeftToRight

					Repeater {
						model: workspaceButton.modelData.windows

						IconImage {
							required property NiriWindow modelData

							implicitWidth: 24
							implicitHeight: 24
							source: Icons.getAppIcon(modelData.appId)
						}
					}
				}
			}
		}
	}
}
