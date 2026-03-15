import QtQuick
import qs.widgets
import qs.utils
import qs.services

IconSlider {
	id: root

	to: 100

	property bool ready: false
	onValueChanged: {
		if (ready) {
			Brightness.set(value)
		} else {
			ready = true
		}
	}

	Binding {
		target: root
		property: "value"
		when: !root.pressed
		value: Brightness.brightness
	}

	icon: Icons.pickIcon(value / 100, ["", "", ""])
}
