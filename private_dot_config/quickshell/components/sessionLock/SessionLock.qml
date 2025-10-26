pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

Item {
	IpcHandler {
		target: "sessionLock"
		function lock() {
			// Lock the session immediately to avoid potentially leaving the
			// session unlocked when it goes to sleep
			loader.active = true
		}
	}

	LazyLoader {
		id: loader

		Item {
			Scope {
				id: lockContext

				// These properties are in the lockContext and not individual lock surfaces
				// so all surfaces can share the same state.
				property string currentText: ""
				property bool unlockInProgress: false
				property bool showFailure: false

				// Clear the failure text once the user starts typing.
				onCurrentTextChanged: showFailure = false

				function tryUnlock() {
					if (currentText === "") return
					lockContext.unlockInProgress = true
					pam.start()
				}

				PamContext {
					id: pam

					// Its best to have a custom pam config for quickshell, as the system one
					// might not be what your interface expects, and break in some way.
					// This particular example only supports passwords.
					configDirectory: Quickshell.shellDir + "/pam"
					config: "password.conf"

					// pam_unix will ask for a response for the password prompt
					onPamMessage: {
						if (this.responseRequired) {
							this.respond(lockContext.currentText)
						}
					}

					// pam_unix won't send any important messages so all we need is the completion status.
					onCompleted: result => {
						if (result == PamResult.Success) {
							lock.locked = false
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
						readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive
						anchors.fill: parent
						color: colors.window

						Button {
							text: "Its not working, let me out"
							onClicked: lockContext.unlocked()
						}

						Label {
							id: clock
							property var date: new Date()

							anchors {
								horizontalCenter: parent.horizontalCenter
								top: parent.top
								topMargin: 100
							}

							// The native font renderer tends to look nicer at large sizes.
							renderType: Text.NativeRendering
							font.pointSize: 80

							// updates the clock every second
							Timer {
								running: true
								repeat: true
								interval: 1000

								onTriggered: clock.date = new Date()
							}

							// updated when the date changes
							text: {
								const hours = this.date.getHours().toString().padStart(2, '0')
								const minutes = this.date.getMinutes().toString().padStart(2, '0')
								return `${hours}:${minutes}`
							}
						}

						ColumnLayout {
							// Uncommenting this will make the password entry invisible except on the active monitor.
							// visible: Window.active

							anchors {
								horizontalCenter: parent.horizontalCenter
								top: parent.verticalCenter
							}

							RowLayout {
								TextField {
									id: passwordBox

									implicitWidth: 400
									padding: 10

									focus: true
									enabled: !lockContext.unlockInProgress
									echoMode: TextInput.Password
									inputMethodHints: Qt.ImhSensitiveData

									// Update the text in the lockContext when the text in the box changes.
									onTextChanged: lockContext.currentText = this.text

									// Try to unlock when enter is pressed.
									onAccepted: lockContext.tryUnlock()

									// Update the text in the box to match the text in the lockContext.
									// This makes sure multiple monitors have the same text.
									Connections {
										target: lockContext

										function onCurrentTextChanged() {
											passwordBox.text = lockContext.currentText
										}
									}
								}

								Button {
									text: "Unlock"
									padding: 10

									// don't steal focus from the text box
									focusPolicy: Qt.NoFocus

									enabled: !lockContext.unlockInProgress && lockContext.currentText !== ""
									onClicked: lockContext.tryUnlock()
								}
							}

							Label {
								visible: lockContext.showFailure
								text: "Incorrect password"
							}
						}
					}
				}
			}
		}
	}
}
