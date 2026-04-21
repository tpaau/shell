//@ pragma Env QS_NO_RELOAD_POPUP=1
///@ pragma DropExpensiveFonts

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.modules.statusBar
import qs.modules.screenDecorations
import qs.modules.sessionManagement
import qs.modules.desktop
import qs.modules.sessionLock
import qs.modules.overviewButtons
import qs.modules.exclusions
import qs.modules.settingsApp
import qs.modules.floatingContent
import qs.modules.desktopToast
import qs.services
import qs.services.apps
import qs.services.notifications

ShellRoot {
	// Bring some services into scope immediately
	Component.onCompleted: {
		Brightness.dummyInit()
		Apps.dummyInit()
		Notifications.dismiss(null)
		MprisService.getArtUrl()
		Session.dummyInit()
		Pipewire.init()
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
						item: overviewButtons.region
					}

					OverviewButtons {
						id: overviewButtons
						screen: root.modelData
					}
				}

				PanelWindow {
					screen: root.modelData

					color: "transparent"
					mask: Region {
						regions: [
							Region { item: statusBar.region },
							Region { item: sessionManagement.region },
							Region { item: floatingContent.region },
						]
					}
					WlrLayershell.layer: WlrLayer.Overlay
					exclusionMode: ExclusionMode.Ignore
					WlrLayershell.keyboardFocus: floatingContent.exclusiveFocus
						|| sessionManagement.exclusiveFocus ?
						WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

					anchors {
						top: true
						right: true
						bottom: true
						left: true
					}

					ScreenDecorations {
						screen: root.modelData
					}
					StatusBar {
						id: statusBar
						screen: root.modelData
					}
					FloatingContent {
						id: floatingContent
						otherItemOpen: sessionManagement.exclusiveFocus
						screen: root.modelData
					}
					SessionManagement {
						id: sessionManagement
						otherItemOpen: floatingContent.active
						screen: root.modelData
					}

					Toast {
						screen: root.modelData
					}

					FpsCounter {}
				}

				Desktop { screen: root.modelData }
			}
		}

		SettingsApp {}
	}
}
