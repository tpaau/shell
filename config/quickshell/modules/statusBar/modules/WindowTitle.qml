import QtQuick
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.widgets
import qs.services.niri

ModuleGroup {
	Item {
		implicitWidth: BarConfig.isHorizontal ? text.width : text.height
		implicitHeight:  BarConfig.isHorizontal ? text.height : text.width
		clip: true

		StyledText {
			id: text
			anchors.centerIn: parent
			text: Niri.overviewOpened ? "Overview"
				: Niri.focusedWindow?.title ?? "Desktop"
			rotation: BarConfig.isHorizontal ? 0 : 90
			// TODO: Derive the max size from bar module sizes
			width: Math.min(implicitWidth, 100)
			elide: Text.ElideRight
		}
	}
}
