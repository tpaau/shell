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
	id: root

	Item {
		implicitWidth: rootGrid.implicitWidth
		implicitHeight: rootGrid.implicitHeight

		GridLayout {
			id: rootGrid
			rows: 1
			columns: 1
			flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
				: GridLayout.LeftToRight

			Repeater {
				id: workspaceRepeater
				model: Niri.workspaces

				StyledButton {
					id: workspaceButton

					required property Workspace modelData

					readonly property bool focused: modelData?.isFocused ?? false

					z: -2
					implicitWidth: Math.max(BarConfig.isHorizontal ?
						grid.implicitWidth + 2 * BarConfig.properties.padding
						: BarConfig.properties.size - 4 * BarConfig.properties.padding,
						BarConfig.properties.size - 4 * BarConfig.properties.padding)
					implicitHeight: Math.max(BarConfig.isHorizontal ?
						BarConfig.properties.size - 4 * BarConfig.properties.padding
						: grid.implicitHeight + 2 * BarConfig.properties.padding,
						BarConfig.properties.size - 4 * BarConfig.properties.padding)
					radius: (BarConfig.properties.size - 2 * BarConfig.properties.padding) / 2
					theme: StyledButton.Primary
					color: "transparent"

					onClicked: modelData?.focus()

					Rectangle {
						anchors.centerIn: parent
						implicitWidth: 6
						implicitHeight: 6
						radius: 3
						color: Qt.alpha(
							workspaceButton.focused ?
								Theme.palette.on_primary
								: Theme.palette.on_surface, 
							workspaceButton.modelData?.windows.length === 0 ?? false ?
								0.7
								: 0.0
						)
						Behavior on color { M3ColorAnim { data: Anims.current.effects.fast } }
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
								z: 2
								id: rect

								required property NiriWindow modelData

								radius: width / 4
								implicitWidth: BarConfig.properties.size - 6 * BarConfig.properties.padding
								implicitHeight: BarConfig.properties.size - 6 * BarConfig.properties.padding
								color: "transparent"

								Image {
									anchors.fill: parent
									asynchronous: true
									mipmap: true
									source: Icons.getAppIcon(rect.modelData.appId, "missing-image")
									sourceSize.width: width
									sourceSize.height: height
								}
							}
						}
					}
				}
			}
		}

		Rectangle {
			readonly property Item focusedWorkspace: rootGrid.children.find(w => w.focused) ?? null
			z: -1
			x: focusedWorkspace?.x ?? 0
			y: focusedWorkspace?.y ?? 0
			implicitWidth: focusedWorkspace?.implicitWidth ?? 0
			implicitHeight: focusedWorkspace?.implicitHeight ?? 0
			radius: Math.min(width, height) / 2
			color: Theme.palette.primary

			Behavior on x {
				enabled: BarConfig.isHorizontal
				M3NumberAnim { data: Anims.current.effects.fast }
			}
			Behavior on y {
				enabled: !BarConfig.isHorizontal
				M3NumberAnim { data: Anims.current.effects.fast }
			}
			Behavior on implicitWidth {
				enabled: BarConfig.isHorizontal
				M3NumberAnim { data: Anims.current.effects.fast }
			}
			Behavior on implicitHeight {
				enabled: !BarConfig.isHorizontal
				M3NumberAnim { data: Anims.current.effects.fast }
			}
		}
	}
}
