//@ pragma Env QS_NO_RELOAD_POPUP=1

import QtQuick
import Quickshell
import qs.components.statusBar
import qs.components.volumeOsd
import qs.components.brightnessOsd
import qs.components.roundedScreenEdges
import qs.components.notificationDaemon
import qs.components.quickSettings
import qs.components.sessionManagement
import qs.components.desktop
import qs.components.overviewButtons
import qs.components.bottomContent
import qs.components.sessionLock
import qs.services

ShellRoot {
	id: root

	readonly property BottomContent bottomContent: BottomContent {}
	readonly property QuickSettings quickSettings: QuickSettings {}

	Component.onCompleted: {
		ShellIpc.quickSettings = quickSettings
		ShellIpc.bottomContent = bottomContent

		// This is to bring the MediaControl service into scope even if it isn't
		// currently used by the shell. If the service isn't in scope, it cannot
		// provide shortcut actions like play, pause, next, previous, etc.
		MediaControl.getArtUrl()

		// Other dummy methods for bringing services into scope
		AppLauncher.close()
	}

	StatusBar {}
	RoundedScreenEdges {}
	VolumeOsd {}
	BrightnessOsd {}
    NotificationDaemon {}
	SessionManagement {}
	Desktop {}
	OverviewButtons {}
	SessionLock {}
}
