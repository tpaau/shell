pragma Singleton

import QtQuick
import Quickshell
import qs.modules.quickSettings

Singleton {
	signal closePopups()
	signal closeToasts()
	signal displayIndicatorToast(comp: Component)

	property list<QuickSettings> quickSettingsList: []
}
