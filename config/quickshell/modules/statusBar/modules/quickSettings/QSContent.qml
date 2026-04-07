import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

RowLayout {
	id: root

	readonly property int margin: Config.spacing.small
	readonly property int radius: Config.rounding.normal

	spacing: Config.spacing.large

	MediaControl {}

	ColumnLayout {
		id: grid
		Layout.alignment: Qt.AlignTop
		spacing: root.radius

		Column {
			spacing: root.radius
			RowLayout {
				spacing: root.radius
				BluetoothButton {}
				CaffeineButton {}
			}
			RowLayout {
				spacing: root.radius
				DoNotDisturbButton { spacing: root.radius }
				DarkModeButton { spacing: root.radius }
			}
		}

		Column {
			Layout.alignment: Qt.AlignTop
			spacing: root.radius

			SinkSlider {
				implicitWidth: grid.width
				implicitHeight: 50
			}
			SourceSlider {
				implicitWidth: grid.width
				implicitHeight: 50
			}
			BrightnessSlider {
				implicitWidth: grid.width
				implicitHeight: 50
			}
		}

		Item {
			Layout.fillWidth: true
			Layout.fillHeight: true

			SessionButtonGroup {
				id: sessionButtons
				anchors {
					right: parent.right
					bottom: parent.bottom
				}
			}
		}
	}
}
