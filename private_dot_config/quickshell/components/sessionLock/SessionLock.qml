pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.widgets
import qs.widgets.scp
import qs.config
import qs.services as S

Item {
	id: root

	property bool locked: false

	IpcHandler {
		target: "sessionLock"

		readonly property string warningStr: "\x1b[1mYou should use the `lock-screen.sh` script or call `qs ipc call sessionLock secureLock` instead of manually locking the session, you might end up with unlocked session if the Quickshell lock fails!\x1b[0m"

		function lock(): string {
			loader.active = true
			return root.locked ? "OK\n" + warningStr : "Err\n" + warningStr
		}

		function secureLock() {
			S.Session.lock()
		}

		function isLocked(): bool {
			return root.locked
		}
	}

	LazyLoader {
		id: loader

		Item {
			Component.onCompleted: root.locked = lock.locked

			Scope {
				id: lockContext

				// These properties are in the lockContext and not individual
				// lock surfaces, so all surfaces can share the same state.
				property string currentText: ""
				property bool unlockInProgress: false
				property bool showFailure: false

				onCurrentTextChanged: showFailure = false

				function tryUnlock() {
					if (currentText === "") return
					lockContext.unlockInProgress = true
					pam.start()
				}

				PamContext {
					id: pam

					configDirectory: Quickshell.shellDir + "/pam"
					config: "password.conf"

					onPamMessage: if (responseRequired) {
						respond(lockContext.currentText)
					}

					onCompleted: result => {
						if (result == PamResult.Success) {
							lock.locked = false
							root.locked = false
							loader.active = false
						}
						else {
							lockContext.currentText = ""
							lockContext.showFailure = true
						}
						lockContext.unlockInProgress = false
					}
				}
			}

			WlSessionLock {
				id: lock
				locked: true

				WlSessionLockSurface {
					Rectangle {
						anchors.fill: parent
						color: Theme.palette.background

						Item {
							id: container
							anchors {
								fill: parent
								margins: Config.spacing.larger
							}

							ColumnLayout {
								anchors {
									horizontalCenter: parent.horizontalCenter
									top: parent.top
								}
								spacing: Config.spacing.smaller

								StyledText {
									renderType: Text.NativeRendering
									font.pixelSize: 6 * Config.font.size.larger
									color: Theme.palette.text
									text: Qt.formatDateTime(S.Time.date, "hh:mm")
								}
								StyledText {
									renderType: Text.NativeRendering
									font.pixelSize: 1.5 * Config.font.size.larger
									Layout.alignment: Qt.AlignCenter
									Layout.topMargin: -24
									color: Theme.palette.text
									text: Qt.formatDateTime(S.Time.date, "ddd, MMM d")
								}
							}

							MediaControl {
								anchors {
									bottom: parent.bottom
									horizontalCenter: parent.horizontalCenter
								}
								orientation: Qt.Horizontal
							}

							SessionButtonGroup {
								id: sessionButtons
								anchors {
									right: parent.right
									bottom: parent.bottom
								}
								lockButtonEnabled: false
							}

							Loader {
								active: Config.scpReferences.enabled &&
									Config.scpReferences.lockscreenCognitohazardEnabled
								asynchronous: true
								anchors {
									bottom: parent.bottom
									left: parent.left
								}
								sourceComponent: ScpCognitohazardDisclaimer { }
							}
						}

						ColumnLayout {
							anchors {
								horizontalCenter: parent.horizontalCenter
								top: parent.verticalCenter
							}

							StyledTextField {
								id: passwordBox

								readonly property int desiredWidth: 400

								placeholderText: width == desiredWidth ?
									lockContext.showFailure ?
									"Incorrect password" : "Enter password..." : ""
								color: lockContext.unlockInProgress || !Window.active ?
									bgRect.color : Theme.palette.text
								placeholderTextColor: width == desiredWidth ?
									Theme.palette.textDim : bgRect.color
								padding: Config.spacing.larger
								leftPadding: lockIcon.width + 2 * padding
								implicitWidth: lockIcon.width + 2 * padding
								Component.onCompleted: {
									implicitWidth = Qt.binding(function() {
										return lockContext.unlockInProgress
										|| !Window.active ?
											lockIcon.width + 2 * padding
											: desiredWidth
									})
								}

								focus: true
								enabled: !lockContext.unlockInProgress
								echoMode: TextInput.Password
								inputMethodHints: Qt.ImhSensitiveData

								onTextChanged: lockContext.currentText = text
								onAccepted: lockContext.tryUnlock()

								Behavior on implicitWidth {
									NumberAnimation {
										duration: Config.animations.durations.popout
										easing.type: Config.animations.easings.popout
									}
								}

								Behavior on color {
									ColorAnimation {
										duration: Config.animations.durations.popout
										easing.type: Config.animations.easings.popout
									}
								}

								Behavior on placeholderTextColor {
									ColorAnimation {
										duration: Config.animations.durations.popout
										easing.type: Config.animations.easings.popout
									}
								}

								StyledIcon {
									id: lockIcon

									anchors {
										verticalCenter: parent.verticalCenter
										left: parent.left
										leftMargin: passwordBox.padding
									}
									font.pixelSize: Config.icons.size.larger
									text: ""
								}

								// This makes sure multiple monitors have the same text.
								Connections {
									target: lockContext

									function onCurrentTextChanged() {
										passwordBox.text = lockContext.currentText
									}
								}
							}
						}

						MouseArea {
							anchors.fill: parent
							propagateComposedEvents: true
							onPressed: (mouse) => {
								mouse.accepted = false
								sessionButtons.closeDialogs()
							}
						}
					}
				}
			}
		}
	}
}
