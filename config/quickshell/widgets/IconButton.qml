import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services.config

StyledButton {
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

	implicitWidth: row.implicitWidth + 2 * padding
	implicitHeight: row.implicitHeight + 2 * padding

	RowLayout {
		id: row
		anchors.centerIn: parent
		spacing: root.spacing

		StyledIcon {
			id: icon
			visible: text !== "" && (root.style === IconButton.ContentStyle.IconAndText || root.style === IconButton.ContentStyle.Icon)
			Layout.alignment: Qt.AlignCenter
			text: "home"
		}
		StyledText {
			id: text
			visible: text !== "" && root.style === IconButton.ContentStyle.IconAndText || root.style === IconButton.ContentStyle.Text
			Layout.alignment: Qt.AlignCenter
			text: "Button"
		}
	}
}
