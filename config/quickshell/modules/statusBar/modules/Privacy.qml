pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import qs.widgets
import qs.theme

// Privacy module used for the status bar.
//
// Kinda broken TBH.
GridLayout {
	id: root

	required property bool isHorizontal

	property color iconColor: Theme.palette.surface

	readonly property bool active: screenshareIcon.active || audioInIcon.active || micIcon.active

	// Screen recording
	readonly property list<PwNode> screenshare: Pipewire.linkGroups.values.filter(
		pwlg => pwlg.source.type === PwNodeType.VideoSource).map(pwlg => pwlg.target)

	// Internal audio device
	readonly property list<PwNode> audioIn: Pipewire.linkGroups.values.filter(
		pwlg => pwlg.source.type === PwNodeType.AudioSource
		&& pwlg.target.type === PwNodeType.AudioInStream).map(pwlg => pwlg.target
	)

	flow: root.isHorizontal ? GridLayout.LeftToRight : GridLayout.TopToBottom
	visible: active

	component PrivacyNode: MaterialIcon {
		required property bool active

		color: root.iconColor
		visible: active
	}

	PrivacyNode {
		id: screenshareIcon
		active: root.screenshare.length > 0
		icon: MaterialIcon.ScreenshotMonitor
	}

	PrivacyNode {
		id: audioInIcon
		active: root.audioIn.length > 0
		icon: MaterialIcon.GraphicEq
	}

	PrivacyNode {
		id: micIcon
		active: false
		icon: MaterialIcon.Mic
	}
}
