import QtQuick
import Quickshell
import qs.services.niri

// Component representing a monitor display recognized by Niri.
//
// Property documentation grabbed from
// https://docs.rs/niri-ipc/latest/niri_ipc/struct.Output.html
QtObject {
	// Name of the output.
	required property string name

	// Textual description of the manufacturer.
	required property string make

	// Textual description of the model.
	required property string model

	// Serial of the output, empty string if unknown.
	required property string serial

	// Physical width of the output in millimeters, 0 if unknown.
	required property int physicalWidth

	// Physical height of the output in millimeters, 0 if unknown.
	required property int physicalHeight

	// Available modes for the output.
	required property list<OutputMode> modes

	// Index of the current mode, -1 if the output is disabled.
	required property int currentMode

	// Whether the `currentMode` is a custom mode.
	required property bool isCustomMode

	// Whether the output supports variable refresh rate.
	required property bool vrrSupported

	// Whether variable refresh rate is enabled on the output.
	required property bool vrrEnabled

	// TODO: Implement logical output.

	function toShellScreen(): ShellScreen {
		return Quickshell.screens.find(s => s.name == name)
	}

	readonly property bool hasFullscreenWindowFocused: {
		const workspace = Niri.workspaces.find(workspace => {
			return workspace.isActive && workspace.output == name
		})
		if (workspace) {
			return Niri.windows.find(window => {
				const result = window.isFocused
					&& window.layout.windowWidth == modes[currentMode].width
					&& window.layout.windowHeight == modes[currentMode].height
				return result
			}) ? true : false
		}
		return false
	}
}
