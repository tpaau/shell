pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import qs.widgets
import qs.services.config
import qs.services as S

WlSessionLock {
	id: root
	locked: true

	required property Scope lockContext
	required property PamContext pam

	WlSessionLockSurface {
		Rectangle {
			anchors.fill: parent
			color: Theme.palette.background

			Image {
				source: Theme.lockscreenWallpaper
				anchors.centerIn: parent
				asynchronous: true
				cache: true
				sourceSize.width: Config.wallpaper.parallax ?
					Math.ceil(parent.width * (1.0 + Config.wallpaper.parallaxStrength))
					: parent.width
				sourceSize.height: Config.wallpaper.parallax ?
					Math.ceil(parent.height * (1.0 + Config.wallpaper.parallaxStrength))
					: parent.height
				fillMode: Image.PreserveAspectCrop

				layer.enabled: true
				layer.effect: MultiEffect {
					blurEnabled: Config.appearance.blur.enabled
					blur: 1
					blurMax: 64
					blurMultiplier: Config.appearance.blur.strength
				}
			}

			StyledButton {
				id: menuButton
				anchors {
					top: parent.top
					right: parent.right
					margins: Config.spacing.normal
				}
				implicitWidth: row.implicitWidth + Config.spacing.normal
				implicitHeight: row.implicitHeight + Config.spacing.normal
				theme: StyledButton.Theme.Surface

				onClicked: menu.open()

				Row {
					id: row
					spacing: Config.spacing.normal
					anchors.centerIn: parent

					StyledIcon { text: "brightness_7" }
					StyledIcon { text: "headphones" }
					StyledIcon { text: "power_settings_new" }
				}

				StyledMenu {
					id: menu
					y: menuButton.height + menuButton.anchors.margins
					x: -width + menuButton.width
					implicitWidth: 450
					padding: menuButton.anchors.margins
					transformOrigin: Popup.TopRight
					color: Theme.palette.surface

					ColumnLayout {
						spacing: Config.spacing.larger

						SinkSlider {
							Layout.topMargin: rounding // Reserve space for the handle
							Layout.leftMargin: gap / 6 // Don't clip the handle
							Layout.rightMargin: gap / 6
							implicitWidth: parent.width - gap / 3 // Don't clip the handle on the right
							implicitHeight: 40
						}
						SourceSlider {
							Layout.leftMargin: gap / 6
							Layout.rightMargin: gap / 6
							implicitWidth: parent.width - gap / 3
							implicitHeight: 40
						}
						BrightnessSlider {
							Layout.leftMargin: gap / 6
							Layout.rightMargin: gap / 6
							implicitWidth: parent.width - gap / 3
							implicitHeight: 40
						}
						SessionButtonGroup {
							id: sessionButtons
							Layout.alignment: Qt.AlignRight
							lockButtonEnabled: false
							color: Theme.palette.surfaceBright
							onPicked: menu.close()
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
					topMargin: Math.floor(-wrapper.height / 2)
				}

				Rectangle {
					id: wrapper
					implicitWidth: column.width
					implicitHeight: mainLayout.implicitHeight + radius
					radius: Config.rounding.large
					color: Theme.palette.surface

					Behavior on implicitHeight { M3NumberAnim { data: Anims.standard.effects.fast } }

					ColumnLayout {
						id: mainLayout
						anchors {
							top: parent.top
							topMargin: wrapper.radius / 2
							horizontalCenter: parent.horizontalCenter
						}
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
								"Authentication failed" : "Enter password..."
							placeholderTextColor: width >= maxWidth ?
								Theme.palette.textDim : bgRect.color
							padding: Config.spacing.larger
							leftPadding: iconWrapper.width + 2 * padding
							implicitWidth: iconWrapper.width + 2 * padding
							Component.onCompleted: {
								implicitWidth = Qt.binding(function() {
									return lockContext.unlockInProgress || !Window.active ?
										Math.min(iconWrapper.width + 2 * padding, maxWidth)
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

							Item {
								id: iconWrapper
								implicitWidth: Config.icons.size.larger
								implicitHeight: Config.icons.size.larger
								anchors {
									verticalCenter: parent.verticalCenter
									left: parent.left
									leftMargin: passwordBox.padding
								}

								StyledIcon {
									anchors.fill: parent
									font.pixelSize: Math.min(width, height)
									opacity: 1 - otherIcon.opacity
									text: ""
								}

								StyledIcon {
									id: otherIcon
									anchors.fill: parent
									font.pixelSize: Math.min(width, height)
									opacity: root.pam.responseVisible && root.pam.message.includes("finger on the fingerprint reader") ? 1 : 0
									text: "fingerprint"

									Behavior on opacity { M3NumberAnim { data: Anims.standard.effects.slow } }
								}
							}

							// This makes sure multiple monitors have the same text.
							Connections {
								target: lockContext

								function onCurrentTextChanged() {
									passwordBox.text = lockContext.currentText
								}
							}
						}
						StyledText {
							opacity: root.pam.responseVisible && root.pam.message !== "" ? 1 : 0
							visible: opacity > 0
							text: root.pam.message
							Layout.alignment: Qt.AlignCenter
							font.pixelSize: Config.font.size.small
							elide: Text.ElideRight
							color: Theme.palette.textDim

							Behavior on opacity { M3NumberAnim { data: Anims.standard.effects.fast } }
						}
					}
				}
				MediaControl {
					id: mediaControl
					orientation: Qt.Horizontal
				}
			}
		}
	}
}
