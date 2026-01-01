// This module doesn't seem to be working well

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.widgets
import qs.config

GridLayout {
	id: root

	required property bool isHorizontal

	readonly property bool active: screenshareIcon.active || audioInIcon.active
		|| locationIcon.active

	// Screen recording
	readonly property list<PwNode> screenshare: Pipewire.linkGroups.values.filter(
		pwlg => pwlg.source.type === PwNodeType.VideoSource).map(pwlg => pwlg.target)

	// Internal audio device
	readonly property list<PwNode> audioIn: Pipewire.linkGroups.values.filter(
		pwlg => pwlg.source.type === PwNodeType.AudioSource
		&& pwlg.target.type === PwNodeType.AudioInStream).map(pwlg => pwlg.target
	)

	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom

	component PrivacyNode: StyledIcon {
		required property bool active

		color: Theme.palette.textInverted
		visible: active
	}

	PrivacyNode {
		id: screenshareIcon
		active: root.screenshare.length > 0
		text: ""
	}

	PrivacyNode {
		id: audioInIcon
		active: root.audioIn.length > 0
		text: ""
	}

	PrivacyNode {
		id: micIcon
		active: false
		text: ""
	}

	PrivacyNode {
		id: locationIcon
		active: false
		text: ""
	}
}
