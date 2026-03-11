import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services.config

TextButton {
	id: root

	property int padding: Config.spacing.small
	property int spacing: padding
	property int style: IconButton.ContentStyle.IconAndText

	property alias icon: icon
	property alias text: text

	enum ContentStyle {
		Icon,
		Text,
		IconAndText
	}

	implicitWidth: text.visible ?
		row.implicitWidth + 2 * padding
		: Math.max(row.implicitWidth, row.implicitHeight) + 2 * padding
	implicitHeight: text.visible ?
		row.implicitHeight + 2 * padding
		: Math.max(row.implicitWidth, row.implicitHeight) + 2 * padding

	RowLayout {
		id: row
		anchors.centerIn: parent
		spacing: root.spacing

		StyledIcon {
			id: icon
			visible: text !== "" && (root.style === IconButton.ContentStyle.IconAndText || root.style === IconButton.ContentStyle.Icon)
			color: root.contentColor
			Layout.alignment: Qt.AlignCenter
			text: "home"
		}
		StyledText {
			id: text
			color: root.contentColor
			visible: text !== "" && root.style === IconButton.ContentStyle.IconAndText || root.style === IconButton.ContentStyle.Text
			Layout.alignment: Qt.AlignCenter
			text: "Button"
		}
	}
}
