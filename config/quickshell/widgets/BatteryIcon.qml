import qs.widgets
import qs.utils

MaterialIcon {
	id: root

	required property real percentage
	property bool isHorizontal: true

	readonly property list<int> iconsHorizontal: [
		MaterialIcon.BatteryAndroid0,
		MaterialIcon.BatteryAndroid1,
		MaterialIcon.BatteryAndroid2,
		MaterialIcon.BatteryAndroid3,
		MaterialIcon.BatteryAndroid4,
		MaterialIcon.BatteryAndroid5,
		MaterialIcon.BatteryAndroid6,
		MaterialIcon.BatteryAndroidFull,
	]
	readonly property list<int> iconsVertical: [
		MaterialIcon.Battery0Bar,
		MaterialIcon.Battery1Bar,
		MaterialIcon.Battery2Bar,
		MaterialIcon.Battery3Bar,
		MaterialIcon.Battery4Bar,
		MaterialIcon.Battery5Bar,
		MaterialIcon.Battery6Bar,
		MaterialIcon.BatteryFull,
	]
	readonly property list<int> iconsCurrent: isHorizontal ?
		iconsHorizontal : iconsVertical

	icon: Icons.pickIcon(percentage, iconsCurrent)
}
