//@ pragma Env QS_NO_RELOAD_POPUP=1

pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components.statusBar
import qs.components.quickSettings
import qs.components.screenDecorations
import qs.components.sessionManagement
import qs.components.desktop
import qs.components.sessionLock
import qs.components.overviewButtons
import qs.components.exclusions
import qs.components.settingsApp
import qs.components.activateLinux
import qs.components.floatingContent
import qs.services
import qs.services.notifications

ShellRoot {
	// Bring some services into scope immediately
	Component.onCompleted: {
		MediaControl.getArtUrl()
		NiriConfig.write()
		Notifications.dismiss(null)
	}

	SessionManagement {}
	SessionLock {}

	Scope {
		Variants {
			model: Quickshell.screens

			Item {
				id: root

				required property ShellScreen modelData

				Exclusions {
					screen: root.modelData
				}

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
							Region {
								item: statusBar.mainRegion
							},
							Region {
								item: statusBar.popupRegion
							},
							Region {
								item: overviewButtons.region
							},
							Region {
								item: quickSettings.region1
							},
							Region {
								item: quickSettings.region2
							}
						]
					}

					ScreenDecorations {}
					StatusBar {
						id: statusBar
						screen: root.modelData
					}
					OverviewButtons {
						id: overviewButtons
					}
					QuickSettings {
						id: quickSettings
					}
				}

				PanelWindow {
					id: overlay

					color: "transparent"
					mask: Region {
						regions: [
							Region {
								item: floatingContent.region
							}
						]
					}
					WlrLayershell.layer: WlrLayer.Top
					exclusionMode: ExclusionMode.Ignore
					WlrLayershell.keyboardFocus: floatingContent.exclusiveFocus ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

					anchors {
						top: true
						right: true
						bottom: true
						left: true
					}

					FloatingContent {
						id: floatingContent
					}
				}

				Desktop {
					screen: root.modelData
				}
				SettingsApp {}

				FpsCounter {}

				ActivateLinux {
					screen: root.modelData
				}
			}
		}
	}
}
