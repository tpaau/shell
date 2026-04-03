pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.theme
import qs.config
import qs.utils
import qs.services.niri

ModuleGroup {
	GridLayout {
		rows: 1
		columns: 1
		flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
			: GridLayout.LeftToRight

		Repeater {
			model: Niri.workspaces

			StyledButton {
				id: workspaceButton

				required property Workspace modelData

				implicitWidth: Math.max(BarConfig.isHorizontal ?
					grid.implicitWidth + 2 * BarConfig.properties.padding
					: BarConfig.properties.size - 4 * BarConfig.properties.padding,
					BarConfig.properties.size - 4 * BarConfig.properties.padding)
				implicitHeight: Math.max(BarConfig.isHorizontal ?
					BarConfig.properties.size - 4 * BarConfig.properties.padding
					: grid.implicitHeight + 2 * BarConfig.properties.padding,
					BarConfig.properties.size - 4 * BarConfig.properties.padding)
				radius: (BarConfig.properties.size - 2 * BarConfig.properties.padding) / 2
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
					flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
						: GridLayout.LeftToRight

					Repeater {
						model: workspaceButton.modelData.windows

						ClippingRectangle {
							id: rect

							required property NiriWindow modelData

							radius: width / 4
							implicitWidth: BarConfig.properties.size - 6 * BarConfig.properties.padding
							implicitHeight: BarConfig.properties.size - 6 * BarConfig.properties.padding
							color: "transparent"

							IconImage {
								anchors.fill: parent
								asynchronous: true
								mipmap: true
								source: Icons.getAppIcon(rect.modelData.appId)
							}
						}
					}
				}
			}
		}
	}
}
