import qs.components.quickSettings
import qs.services

QSToggleButton {
	id: caffeineButton
	icon: Cache.notifications.doNotDisturb ? "" : ""

	toggled: Cache.notifications.doNotDisturb
	onClicked: Cache.notifications.doNotDisturb = !Cache.notifications.doNotDisturb
}
