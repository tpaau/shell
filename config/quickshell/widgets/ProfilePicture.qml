import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.theme

ClippingRectangle {
	id: root

	property string fallbackImage: ""

	radius: Math.min(width, height) / 2
	color: Theme.palette.surface_container

	Image {
		source: Quickshell.env("HOME") + "/.face"
		asynchronous: true
		mipmap: true
		anchors.fill: parent

		sourceSize.width: width

		onStatusChanged: if (status === Image.Error) {
			console.warn("Failed loading profile picture, settings fallback")
			source = root.fallbackImage
		}
	}
}
