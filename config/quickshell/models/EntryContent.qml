import QtQuick

QtObject {
	property string icon: "home" // Material icon name to use for this entry
	property string text: "Entry" // The title of the entry

	// Whether the entry is selected in the parent widget.
	//
	// What this means varies between widgets.
	property bool selected: false

	signal triggered()
}
