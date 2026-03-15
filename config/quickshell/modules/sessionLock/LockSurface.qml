pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import Quickshell.Services.UPower
import qs.widgets
import qs.config
import qs.theme
import qs.services as S

WlSessionLock {
	id: root
	locked: true

	required property Scope lockContext
	required property PamContext pam

	WlSessionLockSurface {
		Rectangle {
			anchors.fill: parent
			color: Theme.palette.surface

			Image {
				source: Config.wallpaper.lockscreen
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
					autoPaddingEnabled: false
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
				theme: StyledButton.Theme.OnSurfaceContainer

				layer.enabled: true
				layer.effect: StyledShadow { strength: 0.5 }

				onClicked: menu.open()

				Row {
					id: row
					spacing: Config.spacing.normal
					anchors.centerIn: parent

					MaterialIcon { icon: MaterialIcon.Brightness7 }
					MaterialIcon { icon: MaterialIcon.Headphones }
					MaterialIcon { icon: MaterialIcon.PowerSettingsNew }
				}

				StyledMenu {
					id: menu
					y: menuButton.height + menuButton.anchors.margins
					x: -width + menuButton.width
					implicitWidth: 450
					padding: menuButton.anchors.margins
					transformOrigin: Popup.TopRight
					color: Theme.palette.surface

					contentItem: ColumnLayout {
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
						RowLayout {
							id: bottomRow
							implicitWidth: menu.implicitWidth - 2 * menu.padding

							BatteryCircleIndicator {
								percentage: UPower.displayDevice?.percentage ?? 0.0
								Layout.alignment: Qt.AlignCenter
							}
							Item {
								Layout.fillWidth: true
								implicitHeight: sessionButtons.implicitHeight

								SessionButtonGroup {
									id: sessionButtons
									anchors.right: parent.right
									lockButtonEnabled: false
									color: Theme.palette.surface_container
									onPicked: menu.close()
								}
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
						color: Theme.palette.primary_fixed
						text: Qt.formatDateTime(S.Time.date, "hh:mm")
					}
					StyledText {
						renderType: Text.NativeRendering
						font.pixelSize: 1.5 * Config.font.size.larger
						Layout.alignment: Qt.AlignCenter
						Layout.topMargin: -24
						color: Theme.palette.primary_fixed
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
					color: mediaControl.color

					layer.enabled: true
					layer.effect: StyledShadow { strength: 0.5 }

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
						}
						StyledTextField {
							id: passwordBox
							Layout.alignment: Qt.AlignCenter

							readonly property int maxWidth: column.width - 2 * Config.spacing.normal

							color: lockContext.unlockInProgress || !Window.active ?
								"transparent" : Theme.palette.primary_fixed
							placeholderText: lockContext.showFailure ?
								Config.sessionLock.authMethod === Config.AuthenticationMethod.Password ?
									"Wrong password" : "Authentication failed"
								: "Enter password..."
							placeholderTextColor: width >= maxWidth ?
								Qt.alpha(color, inactiveOpacity) : bgRect.color
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

								MaterialIcon {
									anchors.fill: parent
									implicitSize: Math.min(width, height)
									opacity: 1 - otherIcon.opacity
									icon: MaterialIcon.Lock
								}

								MaterialIcon {
									id: otherIcon
									anchors.fill: parent
									implicitSize: Math.min(width, height)
									opacity: root.pam.responseVisible &&
										root.pam.message.includes("finger on the fingerprint reader") ? 
										1 : 0
									icon: MaterialIcon.Fingerprint

									Behavior on opacity {
										M3NumberAnim { data: Anims.standard.effects.slow }
									}
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
							theme: StyledText.Theme.RegularDim

							Behavior on opacity { M3NumberAnim { data: Anims.standard.effects.fast } }
						}
					}
				}
				MediaControl {
					id: mediaControl
					orientation: MediaControl.Horizontal
					layer.enabled: true
					layer.effect: StyledShadow { strength: 0.5 }
				}
			}
		}
	}
}
