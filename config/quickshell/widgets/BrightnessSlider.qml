import QtQuick
import Quickshell
import qs.widgets
import qs.utils
import qs.services

IconSlider {
	id: root

	required property ShellScreen screen

	to: 1

	onValueChanged: if (screen) { Brightness.setBrightness(value) }

	Binding {
		target: root
		property: "value"
		when: !root.pressed
		value: Brightness.monitors.find(m => m.modelData == root.screen)?.brightness ?? 0.0
	}

	icon: Icons.pickIcon(value, ["", "", ""])
}
