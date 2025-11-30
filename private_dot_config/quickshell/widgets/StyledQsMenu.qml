pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config

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
			implicitWidth: root.targetWidth
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

				implicitWidth: loader.implicitWidth
				implicitHeight: loader.implicitHeight

				Component {
					id: buttonComp

					StyledButton {
						implicitHeight: 30
						implicitWidth: root.targetWidth
						regularColor: Theme.palette.buttonDarkRegular
						hoveredColor: Theme.palette.buttonDarkHovered
						pressedColor: Theme.palette.buttonDarkPressed
						radius: Config.rounding.smaller
						onClicked: trayMenu.modelData.triggered()

						StyledText {
							anchors {
								verticalCenter: parent.verticalCenter
								left: parent.left
								leftMargin: 2 * root.spacing
							}
							text: trayMenu.modelData.text
							elide: Text.ElideRight
							width: parent.width -  4 * root.spacing
						}
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
