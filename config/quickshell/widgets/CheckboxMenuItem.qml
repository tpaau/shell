import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

Rectangle {
	id: root

	property int spacing: Config.spacing.small
	property real dimmedOpacity: 0.6
	property string text
	property string subText

	readonly property alias checkbox: checkbox
	readonly property alias icon: icon

	implicitHeight: 40
	radius: Config.rounding.small
	color: "transparent"

	MouseArea {
		id: area
		anchors.fill: parent
		onClicked: checkbox.checked = !checkbox.checked
	}

	RowLayout {
		id: row
		spacing: root.spacing
		anchors.centerIn: parent
		implicitWidth: parent.width - parent.spacing
		implicitHeight: parent.width - parent.spacing

		StyledIcon {
			id: icon
			theme: root.enabled ? StyledIcon.Theme.Regular : StyledIcon.Theme.RegularDim
			dimmedOpacity: root.dimmedOpacity
		}
		Column {
			Layout.preferredWidth: parent.width - icon.implicitWidth - checkbox.implicitWidth - 2 * row.spacing
			StyledText {
				text: root.text
				width: parent.width
				theme: root.enabled ? StyledText.Theme.Regular : StyledText.Theme.RegularDim
				elide: Text.ElideRight
				dimmedOpacity: root.dimmedOpacity
			}
			StyledText {
				text: root.subText
				visible: text && text !== ""
				theme: StyledText.Theme.RegularDim
				width: parent.width
				font.pixelSize: Config.font.size.small
				elide: Text.ElideRight
				dimmedOpacity: root.dimmedOpacity
			}
		}
		Checkbox {
			id: checkbox
			enabled: root.enabled
			interactive: false
			pressed: area.containsPress
			Layout.alignment: Qt.AlignRight
		}
	}
}
