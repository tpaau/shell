import QtQuick
import QtQuick.Layouts
import qs.models
import qs.widgets
import qs.config
import qs.services

ColumnLayout {
	id: root

	spacing: Config.spacing.normal

	DropDownMenu {
		implicitWidth: 230

		entries: [
			DropDownMenuEntry {
				name: "Prevent sleep"
				onSelected: Caffeine.setMode(Caffeine.PreventSleep)
			},
			DropDownMenuEntry {
				name: "Prevent idle"
				onSelected: Caffeine.setMode(Caffeine.PreventIdle)
			},
			DropDownMenuEntry {
				name: "Prevent idle and sleep"
				onSelected: Caffeine.setMode(Caffeine.PreventIdleAndSleep)
			}
		]
	}
	MouseArea {
		implicitWidth: parent.implicitWidth
		implicitHeight: row.implicitHeight
		onClicked: caffeineSwitch.switched = !caffeineSwitch.switched

		RowLayout {
			id: row
			spacing: root.spacing
			implicitWidth: parent.width

			StyledText {
				text: "Enabled"
				Layout.preferredWidth: row.width - caffeineSwitch.implicitWidth - row.spacing
				elide: Text.ElideRight
			}
			Switch {
				id: caffeineSwitch
				switched: Caffeine.running
				interactive: false
				onSwitchedChanged: Caffeine.setRunning(switched)
			}
		}
	}
}
