pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.widgets
import qs.config
import qs.services as S

WlSessionLock {
	id: root
	locked: true

	required property Scope lockContext

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

				SessionButtonGroup {
					id: sessionButtons
					anchors {
						right: parent.right
						bottom: parent.bottom
					}
					lockButtonEnabled: false
				}
			}

			Column {
				id: column
				spacing: Config.rounding.large / 2
				anchors {
					horizontalCenter: parent.horizontalCenter
					top: parent.verticalCenter
					topMargin: -wrapper.height / 2
				}

				Rectangle {
					id: wrapper
					implicitWidth: column.width
					implicitHeight: mainLayout.implicitHeight + radius
					radius: Config.rounding.large
					color: Theme.palette.surface

					ColumnLayout {
						id: mainLayout
						anchors.centerIn: parent
						spacing: Config.spacing.normal
						width: column.width

						ProfilePicture {
							id: pfp
							Layout.alignment: Qt.AlignCenter
							Layout.preferredWidth: 80
							Layout.preferredHeight: 80
						}
						StyledText {
							Layout.alignment: Qt.AlignCenter
							text: S.Session.username
							font.pixelSize: Config.font.size.larger
							font.weight: Config.font.weight.heavy
							color: Theme.palette.textIntense
						}
						StyledTextField {
							id: passwordBox
							Layout.alignment: Qt.AlignCenter

							readonly property int maxWidth: 400

							placeholderText: width === maxWidth ? lockContext.showFailure ? "Incorrect password" : "Enter password..." : ""
							color: lockContext.unlockInProgress || !Window.active ? "transparent" : Theme.palette.text
							placeholderTextColor: width === maxWidth ? Theme.palette.textDim : bgRect.color
							padding: Config.spacing.larger
							leftPadding: lockIcon.width + 2 * padding
							implicitWidth: lockIcon.width + 2 * padding
							Component.onCompleted: {
								implicitWidth = Qt.binding(function () {
									return lockContext.unlockInProgress || !Window.active ? Math.min(lockIcon.width + 2 * padding, maxWidth) : maxWidth
								})
							}

							focus: true
							enabled: !lockContext.unlockInProgress
							echoMode: TextInput.Password
							inputMethodHints: Qt.ImhSensitiveData
							radius: wrapper.radius - column.spacing

							onTextChanged: root.lockContext.currentText = text
							onAccepted: root.lockContext.tryUnlock()

							Behavior on implicitWidth {
								M3NumberAnim {
									data: Anims.standard.spatial.fast
								}
							}

							Behavior on color {
								M3ColorAnim {
									data: Anims.current.effects.fast
								}
							}

							Behavior on placeholderTextColor {
								M3ColorAnim {
									data: Anims.current.effects.fast
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
				}

				MediaControl {
					orientation: Qt.Horizontal
				}
			}

			MouseArea {
				anchors.fill: parent
				propagateComposedEvents: true
				onPressed: mouse => {
					mouse.accepted = false
					sessionButtons.closeDialogs()
				}
			}
		}
	}
}
