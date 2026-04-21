pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.modules.statusBar
import qs.widgets
import qs.config
import qs.theme
import qs.services
import qs.services.niri

Item {
	id: root

	anchors.fill: parent

	required property ShellScreen screen

	readonly property M3AnimData anim: Anims.current.effects.slow
	readonly property bool hide: Niri.outputFromShellScreen(screen).hasFullscreenWindowFocused
	readonly property Item region: {
		if (hide) return null
		return content?.menuOpened ? root : barLoader
	}
	readonly property alias barLoader: barLoader

	property BarContent content: null

	enum Style {
		AttachedRect, // Rectangle with three edges attached to screen edges
		Rect, // Rectangle with one edge attached
		FloatingRect, // Floating rectangle
		Shape // `PopoutShape` attached with one edge
	}

	onHideChanged: if (hide) {
		Ipc.closeBarMenus(screen)
	}

	Loader {
		id: barLoader

		active: BarConfig.properties.enabled
		asynchronous: true

		width: BarConfig.isHorizontal ? parent.width : BarConfig.properties.size
		height: BarConfig.isHorizontal ? BarConfig.properties.size : parent.height

		// Can't use anchors for some reason, causes unexpected behavior
		x: BarConfig.properties.edge === Edges.Right ? parent.width - width : 0
		y: BarConfig.properties.edge === Edges.Bottom ? parent.height - height : 0

		component ContentLoader: Loader {
			anchors.fill: parent
			asynchronous: true
			width: parent.width
			height: parent.height

			sourceComponent: BarContent {
				screen: root.screen
				Component.onCompleted: root.content = this
			}
		}

		Component {
			id: attachedRectWrapper

			Rectangle {
				color: Theme.palette.background
				opacity: root.hide ? 0 : 1
				Behavior on opacity { M3NumberAnim { data: root.anim } }

				ContentLoader {}
			}
		}

		Component {
			id: rectWrapper

			Rectangle {
				id: rect

				readonly property int offsetNormalized: {
					let offset = BarConfig.properties.secondaryOffsets
					if (Config.screenDecorations.edges.enabled) {
						offset += Config.screenDecorations.edges.size
					}
					if (Config.screenDecorations.corners.enabled) {
						offset += Config.rounding.window + Config.wm.windowGaps
					}
					return offset
				}

				opacity: root.hide ? 0 : 1
				Behavior on opacity { M3NumberAnim { data: root.anim } }

				anchors {
					fill: parent
					topMargin: BarConfig.properties.edge === Edges.Top ?
						0
						: BarConfig.isHorizontal ?
							0 : offsetNormalized
					rightMargin: BarConfig.properties.edge === Edges.Right ?
						0
						: BarConfig.isHorizontal ?
							offsetNormalized : 0
					bottomMargin: BarConfig.properties.edge === Edges.Bottom ?
						0
						: BarConfig.isHorizontal ?
							0 : offsetNormalized
					leftMargin: BarConfig.properties.edge === Edges.Left ?
						0
						: BarConfig.isHorizontal ?
							offsetNormalized : 0
				}

				layer.enabled: true
				layer.effect: StyledShadow {}

				readonly property int fullRadius:
					(BarConfig.properties.size - 2 * BarConfig.properties.padding) / 2
					+ 2 * BarConfig.properties.padding
				topRightRadius: BarConfig.properties.edge === Edges.Left
					|| BarConfig.properties.edge === Edges.Bottom ? fullRadius : 0
				topLeftRadius: BarConfig.properties.edge === Edges.Right
					|| BarConfig.properties.edge === Edges.Bottom ? fullRadius : 0
				bottomRightRadius: BarConfig.properties.edge === Edges.Left
					|| BarConfig.properties.edge === Edges.Top ? fullRadius : 0
				bottomLeftRadius: BarConfig.properties.edge === Edges.Right
					|| BarConfig.properties.edge === Edges.Top ? fullRadius : 0
				color: Theme.palette.background

				ContentLoader {}
			}
		}

		Component {
			id: floatingRectWrapper

			Rectangle {
				readonly property int offsetNormalized: {
					let offset = BarConfig.properties.secondaryOffsets
					if (Config.screenDecorations.edges.enabled) {
						offset += Config.screenDecorations.edges.size
					}
					if (Config.screenDecorations.corners.enabled) {
						offset += Config.rounding.window
					}
					return offset
				}

				// TODO: This wrapper should slide, not fade
				opacity: root.hide ? 0 : 1
				Behavior on opacity { M3NumberAnim { data: root.anim } }

				anchors {
					fill: parent
					topMargin: BarConfig.properties.edge === Edges.Top ?
						Config.wm.windowGaps : BarConfig.isHorizontal ?
							-Config.wm.windowGaps : offsetNormalized
					rightMargin: BarConfig.properties.edge === Edges.Right ?
						Config.wm.windowGaps : BarConfig.isHorizontal ?
							offsetNormalized : -Config.wm.windowGaps
					bottomMargin: BarConfig.properties.edge === Edges.Bottom ?
						Config.wm.windowGaps : BarConfig.isHorizontal ?
							-Config.wm.windowGaps : offsetNormalized
					leftMargin: BarConfig.properties.edge === Edges.Left ?
						Config.wm.windowGaps : BarConfig.isHorizontal ?
							offsetNormalized : -Config.wm.windowGaps
				}
				color: Theme.palette.surface
				radius: Math.min(width, height)

				ContentLoader {}
			}
		}

		Component {
			id: shapeWrapper

			PopoutShape {
				id: shape

				alignment: alignmentFromEdge(BarConfig.properties.edge)

				// TODO: This wrapper should slide, not fade
				opacity: root.hide ? 0 : 1
				Behavior on opacity { M3NumberAnim { data: root.anim } }

				readonly property int offsetNormalized: {
					let offset = BarConfig.properties.secondaryOffsets
					if (Config.screenDecorations.edges.enabled) {
						offset += Config.screenDecorations.edges.size
					}
					if (Config.screenDecorations.corners.enabled) {
						offset += Config.rounding.window + Config.wm.windowGaps
					}
					return offset
				}

				anchors {
					fill: parent
					topMargin: BarConfig.properties.edge === Edges.Top ? -1 : BarConfig.isHorizontal ?
						0 : offsetNormalized
					rightMargin: BarConfig.properties.edge === Edges.Right ? -1 : BarConfig.isHorizontal ?
						offsetNormalized : 0
					bottomMargin: BarConfig.properties.edge === Edges.Bottom ? -1 : BarConfig.isHorizontal ?
						0 : offsetNormalized
					leftMargin: BarConfig.properties.edge === Edges.Left ? -1 : BarConfig.isHorizontal ?
						offsetNormalized : 0
				}

				Item {
					anchors {
						fill: parent
						topMargin: BarConfig.isHorizontal ? 0 : shape.radius / 2
						rightMargin: BarConfig.isHorizontal ? shape.radius / 2 : 0
						leftMargin: BarConfig.isHorizontal ? shape.radius / 2 : 0
						bottomMargin: BarConfig.isHorizontal ? 0 : shape.radius / 2
					}
					ContentLoader {}
				}
			}
		}

		sourceComponent: switch (BarConfig.properties.wrapperStyle) {
			case StatusBar.AttachedRect:
				return attachedRectWrapper
			case StatusBar.Rect:
				return rectWrapper
			case StatusBar.FloatingRect:
				return floatingRectWrapper
			case StatusBar.Shape:
				return shapeWrapper
			default:
				console.warn(`Unknown bar wrapper style ID: ${BarConfig.properties.wrapperStyle}. The status bar will not be loaded.`)
				return null
		}
	}
}
