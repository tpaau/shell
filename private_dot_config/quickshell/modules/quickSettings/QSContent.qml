import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services.config

RowLayout {
	id: root

	spacing: Config.spacing.large
	readonly property int margin: Config.spacing.small
	readonly property int radius: Config.rounding.normal

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
			}
		}

		Column {
			Layout.alignment: Qt.AlignTop
			spacing: Config.spacing.larger

			SinkSlider {
				implicitWidth: grid.width
				implicitHeight: 40
				backgroundColor: Theme.palette.surface_container_low
			}
			SourceSlider {
				implicitWidth: grid.width
				implicitHeight: 40
				backgroundColor: Theme.palette.surface_container_low
			}
			BrightnessSlider {
				implicitWidth: grid.width
				implicitHeight: 40
				backgroundColor: Theme.palette.surface_container_low
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
