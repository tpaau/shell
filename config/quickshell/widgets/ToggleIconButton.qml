import qs.widgets
import qs.config

ToggleButton {
	id: root

	property int padding: Config.spacing.normal
	readonly property alias icon: icon

	implicitWidth: icon.implicitWidth + 2 * padding
	implicitHeight: icon.implicitHeight + 2 * padding

	StyledIcon {
		id: icon
		color: root.contentColor
		anchors.centerIn: parent
		text: "home"
	}
}
