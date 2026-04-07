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

	required property int availableSize

	readonly property bool compact: !BarConfig.isHorizontal

	theme: menu.visible ? StyledButton.OnSurfaceContainer : StyledButton.OnSurface
	menuOpened: menu.opened

	onClicked: menu.open()

	Loader {
		id: wrapper

		readonly property int size: 160

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
				readonly property real speed: row.implicitWidth / (duration / 10)

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
					duration: scrollAnim.duration * scrollAnim.speed
				}
				NumberAnimation {
					duration: scrollAnim.duration
				}
				NumberAnimation {
					target: row
					properties: "scroll"
					from: 1.0
					to: 0
					duration: scrollAnim.duration * scrollAnim.speed
				}
			}

			StyledText {
				id: titleText
				text: MprisService.player?.trackTitle ?? "Unknown"
				onTextChanged: {
					scrollAnim.stop()
					row.x = 0
					scrollAnim.start()
				}
			}
			Rectangle {
				color: Theme.palette.on_surface
				anchors.verticalCenter: parent.verticalCenter
				implicitWidth: 6
				implicitHeight: 6
				radius: 3
			}
			StyledText {
				id: artistText
				text: MprisService.player?.trackArtist ?? "Unknown"
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
			additionalPadding: Config.spacing.smaller
			onClicked: MprisService.player?.previous()
		}
		BarButton {
			theme: StyledButton.Primary
			icon.text: MprisService.playbackIcon
			additionalPadding: Config.spacing.smaller / 2
			onClicked: MprisService.player?.togglePlaying()
		}
		BarButton {
			icon.text: "skip_next"
			icon.rotation: BarConfig.isHorizontal ? 0 : 90
			Layout.alignment: Qt.AlignCenter
			additionalPadding: Config.spacing.smaller
			onClicked: MprisService.player?.next()
		}
	}

	BarMenu {
		id: menu
		centered: true

		implicitWidth: mediaControl.implicitWidth
		implicitHeight: mediaControl.implicitHeight
		padding: 0

		contentItem: MediaControl {
			id: mediaControl
			radius: menu.radius
			color: Theme.palette.surface
			orientation: BarConfig.isHorizontal ?
				MediaControl.Horizontal
				: MediaControl.Vertical
		}
	}
}
