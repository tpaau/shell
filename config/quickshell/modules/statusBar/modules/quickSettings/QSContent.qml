import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.config

ColumnLayout {
	id: grid
	spacing: Config.spacing.large

	Column {
		spacing: Config.spacing.normal
		RowLayout {
			spacing: Config.spacing.normal
			BluetoothButton {}
			CaffeineButton {}
		}
		RowLayout {
			spacing: Config.spacing.normal
			DoNotDisturbButton { spacing: Config.spacing.normal }
			DarkModeButton { spacing: Config.spacing.normal }
		}
	}

	Column {
		Layout.alignment: Qt.AlignTop
		spacing: Config.spacing.normal

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

	SessionButtonGroup {
		Layout.alignment: Qt.AlignRight
	}
}
