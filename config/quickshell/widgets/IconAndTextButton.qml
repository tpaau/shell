import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

StyledButton {
	id: root

	property int padding: Config.spacing.small
	property int spacing: padding
	property int style: IconAndTextButton.IconAndText

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
			Layout.alignment: Qt.AlignCenter
			visible: text !== "" && (root.style === IconAndTextButton.IconAndText || root.style === IconAndTextButton.Icon)
			color: root.contentColor
			text: "home"
		}
		StyledText {
			id: text
			Layout.alignment: Qt.AlignCenter
			color: root.contentColor
			visible: text !== "" && root.style === IconAndTextButton.IconAndText || root.style === IconAndTextButton.Text
			text: "Button"
		}
	}
}
