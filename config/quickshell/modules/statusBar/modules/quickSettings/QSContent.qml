import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.config

ColumnLayout {
	id: root
	spacing: Config.spacing.large

	required property ShellScreen screen

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
			implicitWidth: root.width
			implicitHeight: 50
		}
		SourceSlider {
			implicitWidth: root.width
			implicitHeight: 50
		}
		BrightnessSlider {
			implicitWidth: root.width
			implicitHeight: 50
			screen: root.screen
		}
	}

	SessionButtonGroup {
		Layout.alignment: Qt.AlignRight
	}
}
