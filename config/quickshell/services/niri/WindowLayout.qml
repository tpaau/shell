// Component representing a Niri window layout.
//
// Property documentation grabbed from
// https://niri-wm.github.io/niri/niri_ipc/struct.WindowLayout.html

import QtQuick

QtObject {
	// NaN if unavailable.
	required property int columnIndexInScrollingLayout
	required property int tileIndexInScrollingLayout

	// Width of the tile this window is in, including decorations like borders.
	required property real tileWidth

	// Height of the tile this window is in, including decorations like borders.
	required property real tileHeight

	// Width of the window’s visual geometry itself.
	required property int windowWidth

	// Height of the window’s visual geometry itself.
	required property int windowHeight

	// Tile position within the current view of the workspace.
	// NaN if unavailable.
	required property int tilePosInWorkspaceViewX
	required property int tilePosInWorkspaceViewY

	// Location of the window’s visual geometry within its tile.
	required property int windowOffsetInTileX
	required property int windowOffsetInTileY
}
