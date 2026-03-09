// Component representing a window registered by Niri.
//
// Property documentation grabbed from
// https://yalter.github.io/niri/niri_ipc/struct.Window.html

import QtQuick

QtObject {
	// The unique ID of this window.
	required property int windowId

	// The title of this window, eg. "Firefox", "kitty", "Steam". Can be null.
	required property string title

	// Application ID, can be null.
	required property string appId

	// Process ID that created the Wayland connection for this window, if known.
	required property int pid

	// The unique ID of the workspace this window is currently in. Set to -1 if
	// not available (for example when the window is dragged with a mouse).
	required property int workspaceId

	// Whether this window is currently focused.
	required property bool isFocused

	// Whether this window is currently floating.
	required property bool isFloating

	// Whether this window is currently requesting attention.
	required property bool isUrgent
}
