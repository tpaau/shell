import QtQuick

// Component representing a mode for a monitor display recognized by Niri.
//
// Property documentation grabbed from
// https://docs.rs/niri-ipc/latest/niri_ipc/struct.Mode.html
QtObject {
	// Width in physical pixels.
	required property int width

	// Height in physical pixels.
	required property int height

	// Refresh rate in millihertz.
	required property int refreshRate

	// Whether this mode is preferred by the monitor.
	required property bool isPreferred
}
