import QtQuick

// Navigation bar item data, not a visual object
QtObject {
	property string text: "Entry"
	property string icon: "home"

	// Whether the item is currently selected in the navigation bar
	property bool active: false
}
