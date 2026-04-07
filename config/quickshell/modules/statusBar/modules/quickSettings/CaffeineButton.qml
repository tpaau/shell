import qs.modules.statusBar.modules.quickSettings
import qs.services

QSToggleOptionsButton {
	id: caffeineButton
	icon: ""
	primaryText: "Caffeine"
	secondaryText: Caffeine.modeStr
	toggled: Caffeine.running
	innerToggle.onClicked: Caffeine.setRunning(!Caffeine.running)
}
