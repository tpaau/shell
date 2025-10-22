pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: root

	readonly property QtObject popout: PopoutConfig {}

    component PopoutConfig: QtObject {
		readonly property int timeout: 1000
    }
}
