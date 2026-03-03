//@ pragma Env QS_NO_RELOAD_POPUP=1

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.statusBar
import qs.modules.quickSettings
import qs.modules.screenDecorations
import qs.modules.sessionManagement
import qs.modules.desktop
import qs.modules.sessionLock
import qs.modules.overviewButtons
import qs.modules.exclusions
import qs.modules.settingsApp
import qs.modules.activateLinux
import qs.modules.floatingContent
import qs.services
import qs.services.config
import qs.services.notifications

ShellRoot {
	// Bring some services into scope immediately
	Component.onCompleted: {
		MediaControl.getArtUrl()
		Notifications.dismiss(null)
		NiriConfig.dummyInit()
		Session.dummyInit()
	}

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
							Region { item: statusBar.region },
							Region { item: overviewButtons.region },
							Region { item: quickSettings.region }
						]
					}

					ScreenDecorations {}
					StatusBar {
						id: statusBar
						screen: root.modelData
					}
					OverviewButtons { id: overviewButtons }
					QuickSettings { id: quickSettings }
				}

				PanelWindow {
					id: overlay

					color: "transparent"
					mask: Region {
						regions: [
							Region { item: floatingContent.region },
							Region { item: sessionManagement.region }
						]
					}
					WlrLayershell.layer: WlrLayer.Overlay
					exclusionMode: ExclusionMode.Ignore
					WlrLayershell.keyboardFocus: floatingContent.exclusiveFocus || sessionManagement.exclusiveFocus ?
						WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

					anchors {
						top: true
						right: true
						bottom: true
						left: true
					}

					FloatingContent {
						id: floatingContent
						otherItemOpen: sessionManagement.exclusiveFocus
					}
					SessionManagement {
						id: sessionManagement
						otherItemOpen: floatingContent.active
					}
				}

				Desktop { screen: root.modelData }
				SettingsApp {}

				FpsCounter {}

				ActivateLinux { screen: root.modelData }
			}
		}
	}
}
