// Component representing a Niri workspace.
//
// Property documentation grabbed from
// https://yalter.github.io/niri/niri_ipc/struct.Workspace.html

import QtQuick

QtObject {
	// This is the constant, unique ID of the workspace.
	required property int workspaceId

	// Index of the workspace on its monitor. This ID isn't constant as you
	// can move workspaces around, and it isn't unique since you can have
	// multiple monitors, all with their own sets of workspaces.
	required property int idx

	// The name of the workspace, null if the workspace is unnamed.
	// https://yalter.github.io/niri/Configuration%3A-Named-Workspaces.html
	required property string name

	// The name of the output of the workspace, eg. "eDP-1", "HDMI-A-1", null
	// if no monitors are connected.
	required property string output

	// Whether the workspace contains a window that is currently requesting
	// attention.
	required property bool isUrgent

	// Whether the workspace is currently active on its output. Every output
	// has one active workspace.
	required property bool isActive

	// Whether the workspace is currently focused. There is only one focused
	// workspace across all outputs.
	required property bool isFocused

	// The unique ID of the active window. Can be null if the workspace
	// contains no windows.
	required property int activeWindowID

	// List of the windows currently in the workspace. This is not exposed by
	// Niri, but added manually by the Niri service based on the `workspaceId`
	// property of the `NiriWindow` component.
	property list<NiriWindow> windows: []
}
