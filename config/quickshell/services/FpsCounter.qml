import QtQuick
import qs.config

Loader {
    width: 800
    height: 600

	active: Config.debug.showFps
	asynchronous: true

	sourceComponent: Item {
		id: root

		property int frameCount: 0
		property real currentFps: 0.0

		Timer {
			interval: 1000 // Update every 1 second
			running: true
			repeat: true
			onTriggered: {
				root.currentFps = root.frameCount
				root.frameCount = 0
				console.warn(`FPS: ${root.currentFps}`)
			}
		}

		// Invisible Rectangle to detect frame updates
		Rectangle {
			id: frameDetector
			anchors.fill: parent
			visible: false // Make it invisible

			property real test: 0

			// This signal is emitted every time a frame is rendered
			// We can use it to count frames.
			onTestChanged: { // Or any other property that changes with every frame
				root.frameCount++;
			}

			NumberAnimation {
				target: frameDetector
				property: "test"
				from: 0
				to: 1
				duration: 1000
				running: true
				loops: Animation.Infinite
			}
		}
	}
}
