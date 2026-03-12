import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.models
import qs.services.config

ColumnLayout {
	id: root

	readonly property UPowerDevice device: UPower.displayDevice
	readonly property UPowerDevice battery: UPower.devices.values.find(d => d.type === UPowerDeviceType.Battery)

	spacing: Config.spacing.small

	function formatHM(seconds: real): string {
		const hours = Math.floor(seconds / 3600)
		const minutes = Math.floor((seconds - hours * 3600) / 60)

		if (hours > 0) return `${hours}h, ${minutes}m`
		else return `${minutes}m`
	}

	RowLayout {
		id: mainRow
		spacing: root.spacing
		Layout.preferredWidth: Math.max(implicitWidth, root.width)

		BatteryCircleIndicator {
			id: batteryIndicator
			percentage: root.device?.percentage ?? 0.0
		}

		StyledText {
			id: remainingText
			font.pixelSize: Config.font.size.larger
			font.weight: Config.font.weight.heavy
			text: {
				if (!root.device || root.device.state === UPowerDeviceState.Unknown) {
					console.warn("Unknown time")
				} else {
					if (root.device.timeToEmpty == 0 && root.device.timeToFull == 0) {
						return text
					}
					else if (root.device.state === UPowerDeviceState.Discharging || root.device.timeToEmpty > 0) {
						return `${root.formatHM(root.device.timeToEmpty)} remaining`
					}
					else if (root.device.state === UPowerDeviceState.Charging || root.device.timeToEmpty > 0) {
						return `Full in ${root.formatHM(root.device.timeToFull)}`
					}
					else if (root.device.state === UPowerDeviceState.FullyCharged || root.device.percentage >= 0.99) {
						return "Full"
					} 
				}
				return text
			}
		}

		ColumnLayout {
			id: infoLayout
			spacing: 0
			Layout.alignment: Qt.AlignRight

			Row {
				id: row

				StyledIcon {
					text: "bolt"
					font.pixelSize: Config.icons.size.small
				}
				StyledText {
					property real lastGoodChangeRate: 0.0
					text: {
						if (root.device?.changeRate === 0)
							return `${Math.round(lastGoodChangeRate)}W`
						else
							return `${Math.round(root.device?.changeRate)}W`
					}
					font.pixelSize: Config.font.size.small
				}
			}
			Loader {
				active: root.battery?.healthSupported ?? false
				asynchronous: true

				sourceComponent: Row {
					StyledIcon {
						text: "heart_check"
						font.pixelSize: Config.icons.size.small
					}
					StyledText {
						text: `${Math.round(root.battery?.healthPercentage ?? 0)}%`
						font.pixelSize: Config.font.size.small
					}
				}
			}
		}
	}

	Loader {
		active: PowerProfiles.hasPerformanceProfile ?? false
		asynchronous: true

		sourceComponent: ButtonGroup {
			selectedIndex: PowerProfiles.profile ?? 0
			onSelectedIndexChanged: PowerProfiles.profile = selectedIndex
			model: [
				EntryContent {
					text: "Power saver"
					icon: "energy_savings_leaf"
				},
				EntryContent {
					text: "Balanced"
					icon: "balance"
				},
				EntryContent {
					text: "Performance"
					icon: "bolt"
				}
			]
		}
	}

	StyledText {
		visible: !(PowerProfiles.hasPerformanceProfile ?? false)
		font.pixelSize: Config.font.size.small
		theme: StyledText.Theme.RegularDim
		text: "Could not connect to the power profile daemon"
	}
}
