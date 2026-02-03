import qs.modules.quickSettings
import qs.services

QSToggleOptionsButton {
	id: caffeineButton
	icon: ""
	primaryText: "Caffeine"
	secondaryText: Caffeine.enabled ? "On" : "Off"
	toggled: Caffeine.enabled
	innerToggle.onClicked: Caffeine.enabled = !Caffeine.enabled
}
