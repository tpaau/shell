import QtQuick

QtObject {
	// This is the unique ID of the workspace.
	required property int workspaceId

	// The index of the workspace on a monitor. This index is not unique, as
	// you can have multiple monitors, all with their own sets of workspaces.
	required property int idx

	// The name of the workspace. See
	// https://yalter.github.io/niri/Configuration%3A-Named-Workspaces.html
	// for details.
	required property string name

	// The name of the output of the workspace. For example "eDP-1", "HDMI-A-1",
	// etc.
	required property string output

	required property bool isUrgent

	required property bool isActive

	// Whether the workspace is currently focused.
	required property bool isFocused

	required property int activeWindowID

	// List of the windows currently in the workspace.
	property list<NiriWindow> windows: []

	onWindowsChanged: console.info("Windows changed!")
}
