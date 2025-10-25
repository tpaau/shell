pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import Quickshell.Widgets
import qs.widgets
import qs.animations
import qs.config
import qs.services

Item {
	id: root

	required property NotificationMeta notif
	required property int spacing

	readonly property real contentFadeMult: 1.5
	readonly property int transitionDur: Config.animations.durations.shorter

	property bool open: false
	property string summary: Config.notifications.fallbackSummary
	property string body: Config.notifications.fallbackBody
	property string appName: Config.notifications.fallbackAppName
	property list<NotificationAction> actions: []
	property int urgency: NotificationUrgency.Normal
	Component.onCompleted: {
		open = true
		if (notif.data) {
			if (notif.data.summary != "") {
				summary = notif.data.summary
			}
			if (notif.data.body != "") {
				body = notif.data.body
			}
			if (notif.data.appName != "") {
				appName = notif.data.appName
			}
			actions = notif.data.actions
			urgency = notif.data.urgency
		}
	}

	function dismiss() {
		if (x >= 0) x = width + spacing
		else x = -width
	}

	onXChanged: {
		if (!mouseArea.containsPress
		&& (x >= width + spacing || x <= -width)) {
			open = false
		}
	}

	readonly property int desiredHeight:
		notif.expanded ?
		headLayout.height + rootLayout.spacing + bodyLayout.height + spacing
		: headLayout.height + spacing

	Connections {
		target: root.notif
		function onDataChanged() {
			if (!root.notif.data) root.dismiss()
		}
	}

	signal dismissed(NotificationMeta meta)

	implicitWidth: Config.notifications.width
	implicitHeight: open ? desiredHeight + spacing : 0
	onImplicitHeightChanged: if (!open && implicitHeight <= 0) {
		notif.data?.dismiss()
	}

	Behavior on implicitHeight {
		PopoutAnimation {
			id: heightAnim
			duration: root.transitionDur
		}
	}

	Behavior on x {
		NumberAnimation {
			id: xRestoreAnim
			duration: root.transitionDur
			easing.type: Config.animations.easings.fadeOut
		}
	}

	MouseArea {
		id: mouseArea
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

		onClicked: root.notif.expanded = !root.notif.expanded
		function determineColor(): color {
			if (containsPress) {
				return Theme.pallete.bg.c6
			}
			return Theme.pallete.bg.c4
		}

		drag {
			target: xRestoreAnim.running ? null : root
			axis: Drag.XAxis
			smoothed: true

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
					Math.max(mouseArea.prevX - root.x, 0)
				rightMargin:
					Math.max(mouseArea.prevX + root.x, 0)
			}
			clip: true
			color: Theme.pallete.bg.c3
			radius: Config.rounding.small

			Rectangle {
				z: 1
				id: contentRect
				color: Theme.pallete.bg.c3
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
							color: Theme.pallete.bg.c5

							StyledIcon {
								anchors.centerIn: parent
								text: root.urgency
									== NotificationUrgency.Critical ?
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
								width: root.notif.expanded ?
									parent.width
									: parent.width - elapsedTimer.width
								elide: Text.ElideRight
								text: root.summary
								font.weight: Config.font.weight.heavy
								y: root.notif.expanded ?
									bottomTextObj.y : topTextObj.y

								Behavior on y {
									PopoutAnimation {
										duration: root.transitionDur
									}
								}

								Behavior on width {
									PopoutAnimation {
										duration: root.transitionDur
									}
								}
							}

							StyledText {
								id: appNameText

								text: root.appName
								opacity: root.notif.expanded ? 1 : 0
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
								x: root.notif.expanded ?
									appNameText.contentWidth
									: summaryText.contentWidth
								implicitWidth: layout.width + root.spacing / 2

								Behavior on x {
									PopoutAnimation {
										duration: root.transitionDur
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
											Math.floor((Time.unix
											- root.notif.creationTime) / 60))
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
								opacity: root.notif.expanded ? 0 : 1
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
							color: mouseArea.determineColor()
							Layout.alignment: Qt.AlignTop

							StyledIcon {
								anchors.centerIn: parent
								text: root.notif.expanded ?  "" : ""
							}
						}
					}

					ColumnLayout {
						id: bodyLayout
						spacing: root.spacing / 2
						opacity: root.notif.expanded ? 1 : 0
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
											actionButton.action.text : ""
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
