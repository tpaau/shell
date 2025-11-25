pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import qs.widgets
import qs.config
import qs.services

Item {
	id: root

	required property Notification notif
	required property int spacing

	readonly property real contentFadeMult: 1.5
	readonly property int transitionDur: Config.animations.durations.shorter

	property date creationDate
	property bool open: false
	property bool expanded: false
	property string summary: Config.notifications.fallbackSummary
	property string body: Config.notifications.fallbackBody
	property string appName: Config.notifications.fallbackAppName
	property list<NotificationAction> actions: []
	property int urgency: NotificationUrgency.Normal

	Component.onCompleted: {
		open = true
		creationDate = Time.date
		if (notif) {
			if (notif.summary != "") {
				summary = notif.summary
			}
			if (notif.body != "") {
				body = notif.body
			}
			if (notif.appName != "") {
				appName = notif.appName
			}
			actions = notif.actions
			urgency = notif.urgency
		}
	}

	function dismiss() {
		notifArea.enabled = false
		if (x >= 0) x = width + spacing
		else x = -width
	}

	function dismissImmediate() {
		notif?.dismiss()
		destroy()
	}

	onXChanged: if (open && (x >= width + spacing || x <= -width)) open = false
	onNotifChanged: if (!root.notif) root.dismiss()

	readonly property int desiredHeight: expanded ?
		headLayout.height + rootLayout.spacing + bodyLayout.height + spacing
		: headLayout.height + spacing

	implicitWidth: Config.notifications.width
	implicitHeight: open ? desiredHeight + spacing : 0
	onHeightChanged: if (!open && height <= 0) {
		dismissImmediate()
	}

	Behavior on implicitHeight {
		NumberAnimation {
			id: heightAnim
			duration: root.transitionDur
			easing.type: Config.animations.easings.popout
		}
	}

	Behavior on x {
		NumberAnimation {
			id: xRestoreAnim
			duration: root.transitionDur
			easing.type: Config.animations.easings.fadeOut
		}
	}

	Timer {
		running: !root.open
		interval: heightAnim.duration
		onTriggered: dismissImmediate()
	}

	MouseArea {
		id: notifArea
		visible: root.open

		anchors {
			fill: parent
			topMargin: root.spacing / 2
			bottomMargin: root.spacing / 2
		}

		property real initialX
		property real prevX
		readonly property real dragDelta: Math.abs(prevX - root.x)
		onDragDeltaChanged: contentRect.opacity = 1 - dragDelta / width * root.contentFadeMult

		Component.onCompleted: {
			prevX = x
			initialX = x
		}
		onClicked: root.expanded = !root.expanded

		drag {
			target: xRestoreAnim.running ? null : root
			axis: Drag.XAxis

			onActiveChanged: {
				if (drag.active) {
					prevX = root.x
				}
				else {
					if (dragDelta > Config.notifications.dragDismissThreshold) {
						root.dismiss()
					}
					else {
						root.x = 0
					}
				}
			}
		}

		ClippingRectangle {
			id: wrapper

			anchors {
				fill: parent
				leftMargin:
					Math.max(notifArea.prevX - root.x, 0)
				rightMargin:
					Math.max(notifArea.prevX + root.x, 0)
			}
			clip: true
			color: Theme.palette.surface
			radius: Config.rounding.small

			Rectangle {
				z: 1
				id: contentRect
				color: Theme.palette.surface
				implicitWidth: root.width
				implicitHeight: rootLayout.height + root.spacing

				ColumnLayout {
					id: rootLayout
					anchors {
						fill: parent
						margins: root.spacing / 2
					}
					spacing: root.spacing / 2

					RowLayout {
						id: headLayout
						spacing: root.spacing / 2
						Layout.alignment: Qt.AlignTop

						Rectangle {
							id: notifIcon
							implicitWidth: 45
							implicitHeight: 45
							radius: Math.min(width, height) / 2
							color: Theme.palette.buttonDisabled

							StyledIcon {
								anchors.centerIn: parent
								fill: 0
								text: root.urgency
									=== NotificationUrgency.Critical ?
									"" : ""
								font.pixelSize: Config.icons.size.larger
							}
						}

						Item {
							id: notifTextHeadWrapper
							Layout.fillWidth: true
							implicitHeight: notifIcon.height

							ColumnLayout {
								width: parent.width
								height: parent.height
								Item {
									id: topTextObj
									implicitWidth: parent.width
									Layout.fillHeight: true
									opacity: 0.4
								}
								Item {
									id: bottomTextObj
									implicitWidth: parent.width
									Layout.fillHeight: true
									opacity: 0.4
								}
							}

							StyledText {
								id: summaryText
								width: root.expanded ?
									parent.width
									: parent.width - elapsedTimer.width
								elide: Text.ElideRight
								text: root.summary
								font.weight: Config.font.weight.heavy
								y: root.expanded ?
									bottomTextObj.y : topTextObj.y

								Behavior on y {
									NumberAnimation {
										duration: root.transitionDur
										easing.type: Config.animations.easings.popout
									}
								}

								Behavior on width {
									NumberAnimation {
										duration: root.transitionDur
										easing.type: Config.animations.easings.popout
									}
								}
							}

							StyledText {
								id: appNameText

								text: root.appName
								opacity: root.expanded ? 1 : 0
								y: topTextObj.y

								Behavior on opacity {
									NumberAnimation {
										duration: root.transitionDur
										easing.type:
											Config.animations.easings.fade
									}
								}
							}

							Item {
								id: elapsedTimer
								y: topTextObj.y
								x: root.expanded ?
									appNameText.contentWidth
									: summaryText.contentWidth
								implicitWidth: layout.width + root.spacing / 2

								Behavior on x {
									NumberAnimation {
										duration: root.transitionDur
										easing.type: Config.animations.easings.popout
									}
								}

								RowLayout {
									id: layout
									anchors {
										fill: parent
										leftMargin: root.spacing / 2
									}
									implicitWidth: elapsedTimerSep.contentWidth
										+ spacing
										+ elapsedTimerText.contentWidth

									StyledIcon {
										id: elapsedTimerSep
										text: "●"
										Layout.bottomMargin: 2
										font.pixelSize:
											Config.icons.size.smaller
									}
									StyledText {
										id: elapsedTimerText
										font.pixelSize:
											Config.font.size.small
										text: Time.formatTimeElapsed(
											Math.floor((Time.date
											- root.creationDate) / 60000))
									}
								}
							}

							StyledText {
								width: parent.width
								elide: Text.ElideRight
								font.pixelSize: Config.font.size.small
								text: root.body
								height: bottomTextObj.height
								maximumLineCount: 1
								opacity: root.expanded ? 0 : 1
								y: bottomTextObj.y

								Behavior on opacity {
									NumberAnimation {
										duration: root.transitionDur
										easing.type:
											Config.animations.easings.fade
									}
								}
							}
						}

						Rectangle {
							radius: Config.rounding.normal
							implicitWidth: radius * 2
							implicitHeight: radius * 2
							color: notifArea.containsPress ?
								Theme.palette.buttonDarkPressed
								: Theme.palette.buttonDarkHovered
							Layout.alignment: Qt.AlignTop

							CollapseIcon {
								anchors.centerIn: parent
								expanded: root.expanded
								anim.duration: root.transitionDur
							}
						}
					}

					ColumnLayout {
						id: bodyLayout
						spacing: root.spacing / 2
						opacity: root.expanded ? 1 : 0
						Layout.preferredWidth: parent.width

						Behavior on opacity {
							NumberAnimation {
								duration: root.transitionDur
								easing.type:
									Config.animations.easings.fade
							}
						}

						StyledText {
							wrapMode: Text.WordWrap
							Layout.preferredWidth: parent.width
							text: root.body
						}

						RowLayout {
							id: actionButtonsLayout
							spacing: root.spacing / 2
							Layout.alignment: Qt.AlignHCenter
							visible: root.actions.length > 0

							Repeater {
								model: root.actions.length
								StyledButton {
									id: actionButton

									required property int index
									readonly property NotificationAction action:
										root.actions[index]

									implicitWidth: actionText.width + root.spacing
									implicitHeight: 1.5 * root.spacing

									onClicked: action?.invoke()

									StyledText {
										id: actionText
										anchors {
											centerIn: parent
											margins: root.spacing / 2
										}
										elide: Text.ElideRight
										text: actionButton.action ?
											actionButton.action.text : text
										maximumLineCount: 1
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
