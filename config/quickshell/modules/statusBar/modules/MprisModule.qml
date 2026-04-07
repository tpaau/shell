import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.modules.statusBar
import qs.modules.statusBar.modules
import qs.theme
import qs.config
import qs.services

// Currently unused
ModuleGroup {
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

			StyledText {
				text: MprisService.player?.trackTitle ?? "Unknown"
				rotation: BarConfig.isHorizontal ? 0 : 90
			}
			Rectangle {
				color: Theme.palette.on_surface
				implicitWidth: 6
				implicitHeight: 6
				radius: 3
			}
			StyledText {
				text: MprisService.player?.artist ?? "Unknown"
				rotation: BarConfig.isHorizontal ? 0 : 90
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
			additionalPadding: Config.spacing.smaller
			onClicked: MprisService.player?.next()
		}
	}
}
