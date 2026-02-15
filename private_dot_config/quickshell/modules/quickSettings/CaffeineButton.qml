import qs.modules.quickSettings
import qs.services

QSToggleOptionsButton {
	id: caffeineButton
	icon: ""
	primaryText: "Caffeine"
	secondaryText: Caffeine.running ? "On" : "Off"
	toggled: Caffeine.running
	innerToggle.onClicked: Caffeine.setRunning(!Caffeine.running)
}
