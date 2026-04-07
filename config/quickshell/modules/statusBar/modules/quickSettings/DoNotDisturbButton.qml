import qs.modules.statusBar.modules.quickSettings
import qs.services.notifications

QSToggleButton {
	id: caffeineButton
	icon.text: Notifications.doNotDisturb ? "" : ""
	toggled: Notifications.doNotDisturb
	onClicked: Notifications.toggleDoNotDisturb()
}
