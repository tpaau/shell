import QtQuick
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.widgets
import qs.services
import qs.services.niri

ModuleGroup {
	id: root

	Item {
		implicitWidth: BarConfig.isHorizontal ? text.width : text.height
		implicitHeight:  BarConfig.isHorizontal ? text.height : text.width
		clip: true

		StyledText {
			id: text
			anchors.centerIn: parent
			text: {
				if (Ipc.sessionManagementList.find(
					s => s.screen === root.screen
				)?.opened) {
					return "Session management"
				}
				const floatingContent = Ipc.floatingContentList.find(c => c.screen === root.screen)
				if (floatingContent && floatingContent.opened) {
					if (floatingContent.launcherOpened) return "Launcher"
					return "Floating content"
				}
				if (Niri.overviewOpened) return "Overview"
				return Niri.focusedWindow?.title ?? "Desktop"
			}
			rotation: BarConfig.isHorizontal ? 0 : 90
			// TODO: Derive the max size from bar module sizes
			width: Math.min(implicitWidth, 100)
			elide: Text.ElideRight
		}
	}
}
