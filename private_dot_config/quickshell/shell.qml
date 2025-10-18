//@ pragma Env QS_NO_RELOAD_POPUP=1

import QtQuick
import Quickshell
import qs.components.statusBar
import qs.components.volumeOsd
import qs.components.brightnessOsd
import qs.components.screenOverlay
import qs.components.notificationDaemon
import qs.components.quickSettings
import qs.components.sessionManagement
import qs.components.desktop
import qs.components.overviewButtons

ShellRoot {
	id: root

	readonly property QuickSettings settings: QuickSettings {}
	StatusBar {
		quickSettings: root.settings
	}
	ScreenOverlay {}
	VolumeOsd {}
	BrightnessOsd {}
    NotificationDaemon {}
	SessionManagement {}
	Desktop {}
	OverviewButtons {}
}
