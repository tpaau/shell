import qs.widgets
import qs.utils

StyledIcon {
	id: root

	required property real percentage
	property bool isHorizontal: false

	readonly property list<string> iconsHorizontal:
		["", "", "", "", "", "", "", ""]
	readonly property list<string> iconsVertical:
		["", "", "", "", "", "", "", ""]
	readonly property list<string> iconsCurrent: isHorizontal ?
		iconsHorizontal : iconsVertical

	text: Icons.pickIcon(percentage, iconsCurrent)
}
