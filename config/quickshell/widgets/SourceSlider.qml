import qs.widgets
import qs.services

PwNodeSlider {
	id: root
	node: Pipewire.audioSource
	icon.icon: node?.audio.volume > 0 ? MaterialIcon.Mic : MaterialIcon.MicOff
}
