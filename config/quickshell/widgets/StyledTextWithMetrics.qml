import QtQuick
import qs.widgets

// Styled text with built-in font metrics. Useful for hacking sometimes.
StyledText {
	id: root

	readonly property alias fontMetrics: metrics

	FontMetrics {
		id: metrics
		font: root.font
	}
}
