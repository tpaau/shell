import QtQuick
import qs.widgets
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

	// TODO: Clean this mess up
	icon.icon: {
		if (value < 33) return MaterialIcon.Brightness2
		else if (value < 66) return MaterialIcon.Brightness6
		else return MaterialIcon.BrightnessEmpty
	}
}
