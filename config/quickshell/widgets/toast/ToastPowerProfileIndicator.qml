import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets.toast
import qs.widgets
import qs.config

ToastContent {
	id: root

	implicitWidth: row.implicitWidth
	implicitHeight: row.implicitHeight

	readonly property int profile: PowerProfiles.profile
	onProfileChanged: restartTimer()

	RowLayout {
		id: row
		spacing: Config.spacing.normal

		StyledIcon {
			font.pixelSize: Config.icons.size.larger
			text: switch (root.profile) {
				case PowerProfile.PowerSaver:
					return "energy_savings_leaf"
				case PowerProfile.Balanced:
					return "balance"
				case PowerProfile.Performance:
					return "bolt"
			}
		}
		StyledText {
			font.pixelSize: Config.font.size.large
			text: switch (root.profile) {
				case PowerProfile.PowerSaver:
					return "Power Saver"
				case PowerProfile.Balanced:
					return "Balanced"
				case PowerProfile.Performance:
					return "Performance"
			}
		}
	}
}
