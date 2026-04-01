pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import Quickshell
import qs.modules.statusBar.modules
import qs.widgets

BarMenu {
	id: root
	implicitWidth: 220

	required property Item parentItem
	required property Component submenuComponent

	property bool isSubmenu: false

	onOpenedChanged: {
		if (!isSubmenu) {
			if (opened) parentItem.menuOpened = true
			else parentItem.menuOpened = false
		}
	}

	property alias model: instantiator.model

	Instantiator {
		id: instantiator

		onObjectAdded: (index, object) => {
			if (object instanceof Menu) root.insertMenu(index, object)
			else root.insertItem(index, object)
		}

		onObjectRemoved: (index, object) => {
			if (object instanceof Menu) root.removeMenu(object)
			else root.removeItem(object)
		}

		delegate: DelegateChooser {
			role: "isSeparator"

			DelegateChoice {
				roleValue: false

				delegate: DelegateChooser {
					role: "hasChildren"

					DelegateChoice {
						roleValue: false

						delegate: StyledMenuItem {
							id: menuItem

							required property QsMenuEntry modelData

							text: modelData?.text ?? ""
							enabled: modelData?.enabled ?? false
							checkable: modelData?.enabled ?? false
							onClicked: modelData?.triggered()
							regularColor: root.color
							implicitHeight: 35

							indicator: Loader {
								sourceComponent: Rectangle {
									implicitHeight: 10
									color: "red"
								}
							}
						}
					}
					DelegateChoice {
						roleValue: true
						delegate: root.submenuComponent
					}
				}
			}
			DelegateChoice {
				roleValue: true

				delegate: MenuSeparator {}
			}
		}
	}
}
