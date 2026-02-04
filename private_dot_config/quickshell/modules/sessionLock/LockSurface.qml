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

			ColumnLayout {
				id: buttonColumn
				anchors {
					top: parent.top
					right: parent.right
					margins: spacing
				}
				spacing: Config.spacing.larger

				StyledButton {
					implicitWidth: row.implicitWidth + Config.spacing.normal
					implicitHeight: row.implicitHeight + Config.spacing.normal
					Layout.alignment: Qt.AlignRight
					theme: StyledButton.Theme.surface

					onClicked: popupLoader.toggleOpen()

					Row {
						id: row
						spacing: Config.spacing.normal
						anchors.centerIn: parent

						StyledIcon {
							text: "brightness_7"
						}
						StyledIcon {
							text: "headphones"
						}
						StyledIcon {
							text: "power_settings_new"
						}
					}
				}

				Loader {
					id: popupLoader
					asynchronous: true

					active: false
					property bool isClosing: false
					function toggleOpen() {
						if (!active) {
							isClosing = false
							active = true
						}
						else isClosing = true
					}
					function close() {
						if (active) {
							isClosing = false
							return 0
						}
						return 1
					}

					sourceComponent: Rectangle {
						color: Theme.palette.background
						layer.enabled: true
						layer.samples: Config.quality.layerSamples
						layer.effect: StyledShadow {}
						radius: Config.rounding.normal
						implicitWidth: slidersColumn.implicitWidth + 2 * radius
						implicitHeight: slidersColumn.implicitHeight + 2 * radius

						opacity: 0
						onOpacityChanged: if (opacity <= 0) popupLoader.active = false
						y: -2 * buttonColumn.spacing

						Component.onCompleted: {
							opacity = Qt.binding(() => popupLoader.isClosing ? 0 : 1)
							y = Qt.binding(() => popupLoader.isClosing ?
								-2 * buttonColumn.spacing : 0
							)
						}

						Behavior on opacity {
							M3NumberAnim { data: Anims.current.effects.fast }
						}
						Behavior on y {
							M3NumberAnim { data: Anims.current.effects.fast }
						}

						ColumnLayout {
							id: slidersColumn
							width: 450
							anchors.centerIn: parent
							spacing: Config.spacing.larger

							SinkSlider {
								implicitWidth: parent.width
								implicitHeight: 40
								backgroundColor: Theme.palette.surface
							}
							SourceSlider {
								implicitWidth: parent.width
								implicitHeight: 40
								backgroundColor: Theme.palette.surface
							}
							BrightnessSlider {
								implicitWidth: parent.width
								implicitHeight: 40
								backgroundColor: Theme.palette.surface
							}
							SessionButtonGroup {
								Layout.alignment: Qt.AlignRight
								lockButtonEnabled: false
							}
						}
					}
				}
			}

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

							readonly property int maxWidth: column.width - 2 * Config.spacing.normal

							color: lockContext.unlockInProgress || !Window.active ?
								"transparent" : Theme.palette.text
							placeholderText: lockContext.showFailure ?
								"Incorrect password" : "Enter password..."
							placeholderTextColor: width >= maxWidth ?
								Theme.palette.textDim : bgRect.color
							padding: Config.spacing.larger
							leftPadding: lockIcon.width + 2 * padding
							implicitWidth: lockIcon.width + 2 * padding
							Component.onCompleted: {
								implicitWidth = Qt.binding(function() {
									return lockContext.unlockInProgress || !Window.active ?
										Math.min(lockIcon.width + 2 * padding, maxWidth)
										: maxWidth
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
					id: mediaControl
					orientation: Qt.Horizontal
				}
			}

			MouseArea {
				anchors.fill: parent
				propagateComposedEvents: true
				onPressed: (mouse) => {
					mouse.accepted = false
					popupLoader.close()
				}
			}
		}
	}
}
