import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.widgets
import qs.models
import qs.services.config

ColumnLayout {
	id: root

	readonly property UPowerDevice device: UPower.displayDevice
	readonly property UPowerDevice laptopBattery: UPower.devices.values.find(d => d.isLaptopBattery)

	spacing: Config.spacing.small

	function formatHM(seconds: real): string {
		const hours = Math.floor(seconds / 3600)
		const minutes = Math.floor((seconds - hours * 3600) / 60)

		if (hours > 0) return `${hours}h, ${minutes}m`
		else return `${minutes}m`
	}

	RowLayout {
		spacing: root.spacing

		BatteryCircleIndicator {
			id: batteryIndicator
			percentage: root.device?.percentage ?? 0.0
		}

		ColumnLayout {
			id: dataLayout
			spacing: 0

			StyledText {
				text: `${Math.round(root.device?.percentage * 100)}%`
				font.pixelSize: Config.font.size.large
			}
			StyledText {
				property string lastGoodText: "Calculating..."
				text: {
					if (!root.device || root.device.state === UPowerDeviceState.Unknown) {
						console.warn("Unknown time")
						return "Unknown time remaining"
					} else {
						if (Math.ceil(root.device.percentage * 100) == 100) {
							const text = "Full"
							lastGoodText = text
							return text
						} 
						else if (root.device.timeToEmpty == 0 && root.device.timeToFull == 0) {
							return lastGoodText
						}
						else if (root.device.state === UPowerDeviceState.Discharging) {
							const text = `${root.formatHM(root.device.timeToEmpty)} remaining`
							lastGoodText = text
							return text
						}
						else if (root.device.state === UPowerDeviceState.Charging) {
							const text = `Full in ${root.formatHM(root.device.timeToFull)}`
							lastGoodText = text
							return text
						}
					}
					return lastGoodText
				}
			}
		}

		Item {
			Layout.alignment: Qt.AlignRight
			implicitHeight: infoLayout.implicitHeight
			implicitWidth: Math.max(root.width - batteryIndicator.implicitWidth - dataLayout.implicitWidth - 2 * root.spacing, infoLayout.implicitWidth)

			ColumnLayout {
				id: infoLayout
				anchors.right: parent.right
				spacing: 0

				RowLayout {
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
					active: root.laptopBattery?.healthSupported ?? false
					asynchronous: true

					sourceComponent: RowLayout {
						StyledIcon {
							text: "heart_check"
							font.pixelSize: Config.icons.size.small
						}
						StyledText {
							text: `${Math.round(root.laptopBattery?.healthPercentage)}%`
							font.pixelSize: Config.font.size.small
						}
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
