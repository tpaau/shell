//@ pragma Env QS_NO_RELOAD_POPUP=1

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.components.statusBar
import qs.components.quickSettings
import qs.components.screenDecorations
import qs.components.notificationDaemon
import qs.components.sessionManagement
import qs.components.desktop
import qs.components.bottomContent
import qs.components.appLauncher
import qs.components.sessionLock
import qs.components.overviewButtons
import qs.components.exclusions
import qs.components.settingsApp
import qs.services

ShellRoot {
	Component.onCompleted: {
		// This is to bring the MediaControl service into scope even if it isn't
		// currently used by the shell. If the service isn't in scope, it cannot
		// provide shortcut actions like play, pause, next, previous, etc.
		MediaControl.getArtUrl()
	}

	Scope {
		Variants {
			model: Quickshell.screens

			Item {
				id: root

				required property ShellScreen modelData

				readonly property BottomContent bottomContent: BottomContent {}

				Exclusions {}

				PanelWindow {
					anchors {
						top: true
						right: true
						bottom: true
						left: true
					}

					exclusionMode: ExclusionMode.Ignore
					color: "transparent"
					mask: Region {
						regions: [
							Region { item: statusBar },
							Region { item: overviewButtons.region },
							Region { item: quickSettings.region1 },
							Region { item: quickSettings.region2 },
							Region { item: notificationDaemon }
						]
					}

					ScreenDecorations {}
					NotificationDaemon { id: notificationDaemon }
					StatusBar { id: statusBar }
					OverviewButtons { id: overviewButtons }
					QuickSettings { id: quickSettings }
				}

				AppLauncher {
					bottomContent: root.bottomContent
				}
				SessionManagement {}
				Desktop {}
				SessionLock {}
				SettingsApp {}

				FpsCounter {}
			}
		}
	}
}
