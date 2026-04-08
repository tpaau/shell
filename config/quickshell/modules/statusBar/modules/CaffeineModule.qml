import QtQuick
import QtQuick.Layouts
import qs.models
import qs.widgets
import qs.modules.statusBar.modules
import qs.config
import qs.services

ModuleGroup {
	id: root

	theme: Caffeine.running ? StyledButton.Primary : StyledButton.OnSurface
	menuOpened: menu.opened
	onClicked: menu.open()

	BarIcon {
		text: "coffee"
		color: root.contentColor
	}

	BarMenu {
		id: menu

		implicitWidth: contentItem.implicitWidth + 2 * padding
		implicitHeight: contentItem.implicitHeight + 2 * padding

		contentItem: ColumnLayout {
			id: column

			spacing: Config.spacing.normal

			DropDownMenu {
				implicitWidth: 260

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
					spacing: column.spacing
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

						Connections {
							target: Caffeine

							function onRunningChanged() {
								caffeineSwitch.switched = Caffeine.running
							}
						}
					}
				}
			}
			StyledText {
				theme: StyledText.RegularDim
				text: "Caffeine prevents your system from sleeping and/or idling (dimming the screen and locking your session)."
				Layout.preferredWidth: parent.implicitWidth
				wrapMode: Text.Wrap
				font.pixelSize: Config.font.size.small
			}
		}
	}
}
