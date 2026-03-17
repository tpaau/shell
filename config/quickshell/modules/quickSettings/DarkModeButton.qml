import Quickshell.Services.UPower
import qs.modules.quickSettings
import qs.config

QSToggleButton {
	id: caffeineButton
	icon.text: Config.theme.dark ? "bedtime" : "sunny"
	toggled: Config.theme.dark
	enabled: !Config.theme.forceDarkOnPowerSaver || PowerProfiles.profile !== PowerProfile.PowerSaver
	onClicked: Config.theme.dark = !Config.theme.dark
}
