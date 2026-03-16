import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

Rectangle {
	id: root

	property int spacing: Config.spacing.small
	property real dimmedOpacity: 0.6
	property string text

	readonly property alias switchWidget: switchWidget
	readonly property alias icon: icon

	implicitHeight: 40
	radius: Config.rounding.small
	color: "transparent"

	RowLayout {
		id: row
		spacing: root.spacing
		anchors.centerIn: parent
		implicitWidth: parent.width - 2 * parent.spacing
		implicitHeight: parent.width - 2 * parent.spacing

		StyledIcon {
			id: icon
			theme: root.enabled ? StyledIcon.Theme.Regular : StyledIcon.Theme.RegularDim
			dimmedOpacity: root.dimmedOpacity
		}
		StyledText {
			text: root.text
			theme: root.enabled ? StyledText.Theme.Regular : StyledText.Theme.RegularDim
			Layout.preferredWidth: parent.width - icon.implicitWidth - switchWidget.implicitWidth - 2 * row.spacing
			elide: Text.ElideRight
			dimmedOpacity: root.dimmedOpacity
		}
		Switch {
			id: switchWidget
			enabled: root.enabled
			Layout.alignment: Qt.AlignRight
		}
	}
}
