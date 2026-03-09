import qs.widgets
import qs.services

PwNodeSlider {
	id: root
	node: Pipewire.audioSource
	icon: node?.audio.volume > 0 ? "mic" : "mic_off"
}
