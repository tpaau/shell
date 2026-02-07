pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.widgets

Item {
	id: root

	required property QsMenuHandle menu

	readonly property int spacing: Config.spacing.smaller
	readonly property int targetWidth: 200

	QsMenuOpener {
		id: opener
		menu: root.menu
	}

	implicitWidth: layout.implicitWidth
	implicitHeight: layout.implicitHeight

	Component {
		id: separatorComp

		Rectangle {
			implicitHeight: root.spacing
			implicitWidth: root.targetWidth - 4 * root.spacing
			anchors.horizontalCenter: parent.horizontalCenter
			radius: height / 2
			color: Theme.palette.surface
		}
	}

	ColumnLayout {
		id: layout

		spacing: root.spacing

		Repeater {
			id: repeater

			model: opener.children

			Item {
				id: trayMenu

				required property QsMenuEntry modelData

				Layout.alignment: Qt.AlignCenter

				implicitWidth: loader.implicitWidth
				implicitHeight: loader.implicitHeight

				Component {
					id: buttonComp

					StyledMenuItem {
						implicitHeight: 30
						implicitWidth: root.targetWidth
						onClicked: trayMenu.modelData.triggered()
						text: trayMenu.modelData.text
					}
				}

				Loader {
					id: loader

					active: true
					asynchronous: true
					sourceComponent: {
						if (trayMenu.modelData.isSeparator) {
							return separatorComp
						}
						else {
							return buttonComp
						}
					}
				}
			}
		}
	}
}
