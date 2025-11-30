import QtQuick
import qs.widgets
import qs.utils
import qs.config

Loader {
	id: root

	anchors {
		bottom: parent.bottom
		horizontalCenter: parent.horizontalCenter
	}

	asynchronous: true
	active: false

	function open(component: Component): int {
		const status = Utils.checkComponent(component)
		if (status !== 0) return status
		return 0
	}

	sourceComponent: PopoutShape {
		alignment: PopoutAlignment.bottom
	}
}
