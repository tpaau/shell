import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.theme
import qs.config
import qs.utils
import qs.services

ModuleGroup {
	id: root

	readonly property bool compact: !BarConfig.isHorizontal

	menuOpened: menu.opened

	onClicked: menu.open()

	Loader {
		id: wrapper

		readonly property int size: 200

		clip: true
		asynchronous: true
		active: !root.compact
		visible: !root.compact
		Layout.preferredWidth: size

		sourceComponent: Row {
			id: row
			anchors.verticalCenter: parent.verticalCenter
			spacing: Config.spacing.smaller

			property real scroll: 0.0
			onScrollChanged: x = Utils.lerp(0, parent.width - Math.max(width, implicitWidth), scroll)

			SequentialAnimation {
				id: scrollAnim

				readonly property int duration: 2000

				loops: Animation.Infinite
				Component.onCompleted: restart()

				NumberAnimation {
					duration: scrollAnim.duration
				}
				NumberAnimation {
					target: row
					properties: "scroll"
					from: 0
					to: 1.0
					duration: scrollAnim.duration
				}
				NumberAnimation {
					duration: scrollAnim.duration
				}
				NumberAnimation {
					target: row
					properties: "scroll"
					from: 1.0
					to: 0
					duration: scrollAnim.duration
				}
			}

			StyledText {
				id: titleText
				text: {
					if (MprisService.player) {
						return MprisService.player.trackTitle !== "" ?
							MprisService.player.trackTitle : "Unknown"
					}
					return "No media"
				}
				onTextChanged: {
					scrollAnim.stop()
					row.x = 0
					scrollAnim.start()
				}
			}
			Rectangle {
				color: Theme.palette.on_surface
				visible: MprisService.player && MprisService.player.trackArtist !== ""
				anchors.verticalCenter: parent.verticalCenter
				implicitWidth: 6
				implicitHeight: 6
				radius: 3
			}
			StyledText {
				id: artistText
				visible: MprisService.player && MprisService.player.trackArtist !== ""
				text: MprisService.player?.trackArtist ?? ""
				onTextChanged: {
					scrollAnim.stop()
					row.x = 0
					scrollAnim.start()
				}
			}
		}
	}

	GridLayout {
		rowSpacing: Config.spacing.smaller
		columnSpacing: Config.spacing.smaller
		rows: 1
		columns: 1
		flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
			: GridLayout.LeftToRight

		BarButton {
			icon.text: "skip_previous"
			icon.rotation: BarConfig.isHorizontal ? 0 : 90
			Layout.alignment: Qt.AlignCenter
			additionalPadding: Config.spacing.smaller * 0.75
			theme: StyledButton.Tertiary
			enabled: MprisService.player?.canGoPrevious ?? false
			onClicked: MprisService.player?.previous()
		}
		BarButton {
			theme: StyledButton.Primary
			icon.text: MprisService.playbackIcon
			additionalPadding: Config.spacing.smaller / 4
			enabled: MprisService.player?.canTogglePlaying ?? false
			onClicked: MprisService.player?.togglePlaying()
		}
		BarButton {
			icon.text: "skip_next"
			icon.rotation: BarConfig.isHorizontal ? 0 : 90
			Layout.alignment: Qt.AlignCenter
			additionalPadding: Config.spacing.smaller * 0.75
			theme: StyledButton.Tertiary
			enabled: MprisService.player?.canGoNext ?? false
			onClicked: MprisService.player?.next()
		}
	}

	BarMenu {
		id: menu
		centered: true

		screen: root.screen
		implicitWidth: mediaControl.implicitWidth
		implicitHeight: mediaControl.implicitHeight
		padding: 0

		contentItem: MediaControl {
			id: mediaControl
			radius: menu.radius
			orientation: BarConfig.isHorizontal ?
				MediaControl.Horizontal
				: MediaControl.Vertical
		}
	}
}
