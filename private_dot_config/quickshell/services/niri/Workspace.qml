import QtQuick

QtObject {
	required property int workspaceId

	// The index of the workspace. The index is output-dependant, so the first
	// workspace on a monitor will always have an ID of 1, second 2, and so on.
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
	required property bool isFocused
	required property int activeWindowID

	// Whether the workspace contains one or more windows.
	property bool containsWindow
}
