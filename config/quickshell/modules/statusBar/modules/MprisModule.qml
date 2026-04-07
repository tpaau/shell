import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.theme
import qs.config
import qs.services

ModuleGroup {
	onClicked: menu.open()
	menuOpened: menu.opened

	theme: menu.visible ? StyledButton.OnSurfaceContainer : StyledButton.OnSurface

	Item {
		clip: true

		Layout.preferredWidth: BarConfig.isHorizontal ? 120 : parent.width
		Layout.preferredHeight: BarConfig.isHorizontal ? parent.height : 120

		GridLayout {
			id: grid

			rowSpacing: Config.spacing.smaller
			columnSpacing: Config.spacing.smaller
			rows: 1
			columns: 1
			flow: BarConfig.isHorizontal ? GridLayout.TopToBottom
				: GridLayout.LeftToRight

			y: BarConfig.isHorizontal ? (parent.height - height) / 2 : 0
			x: BarConfig.isHorizontal ? 0 : (parent.width - width) / 2

			Item {
				implicitWidth: BarConfig.isHorizontal ? titleText.width : titleText.height
				implicitHeight:  BarConfig.isHorizontal ? titleText.height : titleText.width
				Layout.alignment: Qt.AlignCenter

				StyledText {
					id: titleText
					anchors.centerIn: parent
					text: MprisService.player?.trackTitle ?? "Unknown"
					rotation: BarConfig.isHorizontal ? 0 : 90
				}
			}
			Rectangle {
				color: Theme.palette.on_surface
				implicitWidth: 6
				implicitHeight: 6
				radius: 3
				Layout.alignment: Qt.AlignCenter
			}
			Item {
				implicitWidth: BarConfig.isHorizontal ? artistText.width : artistText.height
				implicitHeight:  BarConfig.isHorizontal ? artistText.height : artistText.width
				Layout.alignment: Qt.AlignCenter

				StyledText {
					id: artistText
					anchors.centerIn: parent
					text: MprisService.player?.trackArtist ?? "Unknown"
					rotation: BarConfig.isHorizontal ? 0 : 90
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
			additionalPadding: Config.spacing.smaller
			onClicked: MprisService.player?.next()
		}
	}

	BarMenu {
		id: menu
		centered: true

		implicitWidth: mediaControl.implicitWidth + 2 * padding
		implicitHeight: mediaControl.implicitHeight + 2 * padding

		contentItem: MediaControl {
			id: mediaControl
			orientation: BarConfig.isHorizontal ?
				MediaControl.Horizontal
				: MediaControl.Vertical
		}
	}
}
