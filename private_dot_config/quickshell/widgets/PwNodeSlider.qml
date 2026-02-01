import QtQuick
import Quickshell.Services.Pipewire

IconSlider {
	id: root

	required property PwNode node

	Binding {
		target: root
		property: "value"
		when: !root.pressed
		value: root.node?.audio.volume ?? 0
	}
	onValueChanged: if (root.node)
						root.node.audio.volume = value
}
