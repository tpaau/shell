//@ pragma Env QS_NO_RELOAD_POPUP=1

import QtQuick
import Quickshell
import qs.services
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

	readonly property QuickSettings quickSettings: QuickSettings {}

	Component.onCompleted: {
		// This is to bring the MediaControl service into scope even if it isn't
		// currently used by the shell. If the service isn't in scope, it cannot
		// provide shortcut actions like play, pause, next, previous, etc.
		MediaControl.getArtUrl()
		ShellIpc.quickSettings = quickSettings
	}


	StatusBar {}
	ScreenOverlay {}
	VolumeOsd {}
	BrightnessOsd {}
    NotificationDaemon {}
	SessionManagement {}
	Desktop {}
	OverviewButtons {}
}
