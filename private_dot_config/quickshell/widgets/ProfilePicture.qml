import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.config

ClippingRectangle {
	id: root

	property string fallbackImage: ""

	radius: Math.min(width, height) / 2
	color: Theme.palette.surfaceBright

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
