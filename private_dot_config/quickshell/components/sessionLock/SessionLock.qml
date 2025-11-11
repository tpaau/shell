pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.widgets
import qs.config
import qs.services as S

Item {
	IpcHandler {
		target: "sessionLock"
		function lock(): int {
			loader.active = true
			if (loader.status === Loader.Ready) {
				return 0
			}
			return 1
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
					onPamMessage: if (responseRequired) {
						respond(lockContext.currentText)
					}

					// pam_unix won't send any important messages so all we need is the completion status.
					onCompleted: result => {
						if (result == PamResult.Success) {
							lock.locked = false
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

							StyledText {
								id: clock

								anchors {
									horizontalCenter: parent.horizontalCenter
									top: parent.top
								}
								renderType: Text.NativeRendering
								font.pixelSize: 128
								color: Theme.palette.text
								text: Qt.formatDateTime(S.Time.date, "hh:mm")
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
						}

						ColumnLayout {
							anchors {
								horizontalCenter: parent.horizontalCenter
								top: parent.verticalCenter
							}

							visible: Window.active

							StyledTextField {
								id: passwordBox

								readonly property int desiredWidth: 400

								placeholderText: lockContext.showFailure ?
									"Incorrect password" : "Enter password..."
								color: lockContext.unlockInProgress ? 
									bgRect.color : Theme.palette.text
								placeholderTextColor: width == desiredWidth ? 
									Theme.palette.textDim : bgRect.color
								padding: Config.spacing.larger
								leftPadding: lockIcon.width + 2 * padding
								implicitWidth: lockIcon.width + 2 * padding
								Component.onCompleted: {
									implicitWidth = Qt.binding(function() {
										return lockContext.unlockInProgress ?
											lockIcon.width + 2 * padding : desiredWidth
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
