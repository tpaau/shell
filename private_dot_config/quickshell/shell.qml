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
import qs.components.sessionLock
import qs.components.overviewButtons
import qs.components.exclusions
import qs.components.settingsApp
import qs.components.activateLinux
import qs.services

ShellRoot {
	Component.onCompleted: {
		// This is to bring the MediaControl service into scope even if it isn't
		// currently used by the shell. If the service isn't in scope, it cannot
		// provide shortcut actions like play, pause, next, previous, etc.
		MediaControl.getArtUrl()
	}

	SessionManagement {}
	SessionLock {}

	Scope {
		Variants {
			model: Quickshell.screens

			Item {
				id: root

				required property ShellScreen modelData

				Exclusions { screen: root.modelData }

				PanelWindow {
					screen: root.modelData

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
							Region { item: statusBar.mainRegion },
							Region { item: statusBar.popupRegion },
							Region { item: overviewButtons.region },
							Region { item: quickSettings.region1 },
							Region { item: quickSettings.region2 },
							Region { item: notificationDaemon }
						]
					}

					ScreenDecorations {}
					NotificationDaemon { id: notificationDaemon }
					StatusBar {
						id: statusBar
						screen: root.modelData
					}
					OverviewButtons { id: overviewButtons }
					QuickSettings { id: quickSettings }
				}

				Desktop { screen: root.modelData }
				SettingsApp {}

				FpsCounter {}

				ActivateLinux { screen: root.modelData }
			}
		}
	}
}
