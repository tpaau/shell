import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.widgets.toast
import qs.config

ToastContent {
	id: root

	required property string icon
	required property real progress
	property int timeout: Config.toast.defaultTimeout

	implicitWidth: row.implicitWidth
	implicitHeight: row.implicitHeight

	RowLayout {
		id: row
		spacing: Config.spacing.normal

		StyledIcon {
			id: icon
			text: root.icon
			font.pixelSize: Config.icons.size.larger
		}
		ProgressIndicator {
			implicitWidth: 300
			implicitHeight: 6
			progress: root.progress
			Layout.rightMargin: icon.width / 4
		}
	}
}
