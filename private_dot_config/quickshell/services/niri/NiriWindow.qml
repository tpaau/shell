import QtQuick

QtObject {
	required property int windowId

	// The title of the window.
	required property string title

	required property string appId

	// The process ID of the window.
	required property int pid

	required property int workspaceId

	// Whether the window is currently focused.
	required property bool isFocused

	// Whether the window is currently floating.
	required property bool isFloating

	// Whether the window currently requests attention.
	required property bool isUrgent
}
