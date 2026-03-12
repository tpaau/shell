import qs.widgets
import qs.config

CircularProgressIndicator {
	id: root

	property int padding: Config.spacing.small
	required property real percentage

	value: percentage
	implicitSize: Math.max(batIcon.implicitWidth, batIcon.implicitHeight)
		+ 2 * padding

	BatteryIcon {
		id: batIcon
		anchors.centerIn: parent
		percentage: root.percentage
		isHorizontal: true
		font.pixelSize: Config.icons.size.large
		color: root.primaryColor
	}
}
