import qs.modules.quickSettings
import qs.config

QSToggleButton {
	id: caffeineButton
	icon.text: Config.theme.dark ? "bedtime" : "sunny"
	toggled: Config.theme.dark
	onClicked: Config.theme.dark = !Config.theme.dark
}
