import QtQuick
import qs.widgets

StyledListView {
	id: root

	// Whether to use the temporal notification stack
	//   - true:  Uses the temporal stack
	//   - false: Uses the ignored stack
	required property bool useTemporal
}
