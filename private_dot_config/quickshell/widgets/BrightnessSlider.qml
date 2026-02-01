import QtQuick
import qs.widgets
import qs.utils
import qs.services

IconSlider {
	id: root

	to: 100

	Binding {
		target: root
		property: "value"
		when: !root.pressed
		value: Brightness.brightness
	}

	property bool ready: false
	onMoved: {
		if (ready) {
			Brightness.set(value)
		} else {
			ready = true
		}
	}

	icon: Icons.pickIcon(value / 100, ["", "", ""])
}
