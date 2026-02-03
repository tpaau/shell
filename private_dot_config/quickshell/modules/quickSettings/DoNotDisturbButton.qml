import qs.modules.quickSettings
import qs.services.notifications

QSToggleButton {
	id: caffeineButton
	icon: Notifications.doNotDisturb ? "" : ""
	toggled: Notifications.doNotDisturb
	onClicked: Notifications.toggleDoNotDisturb()
}
