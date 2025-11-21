import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.utils

Item {
	id: root

	property bool dark: true
	property real horizontalSize: 40

	readonly property real radius: horizontalSize * 0.2
	readonly property color fgColor: dark ? "#000000" : "#ffffff"
	readonly property color textColor: dark ? "#ffffff" : "#000000"
	readonly property color bgColor: "#888888"

	required property real percentage
	onPercentageChanged: percentage = Utils.clamp(percentage, 0, 1)

	implicitWidth: layout.width
	implicitHeight: layout.height

	RowLayout {
		id: layout
		spacing: 0

		Rectangle {
			id: bgRect

			implicitWidth: root.horizontalSize - secondaryElement.width
			implicitHeight: 0.45 * root.horizontalSize
			radius: root.radius
			clip: true
			color: root.bgColor

			Item {
				anchors {
					top: parent.top
					bottom: parent.bottom
					left: parent.left
				}
				width: parent.width * root.percentage
				clip: true

				Rectangle {
					anchors {
						top: parent.top
						bottom: parent.bottom
						left: parent.left
					}
					radius: root.radius
					width: bgRect.width
					color: root.fgColor
				}
			}
		}

		Item {
			id: secondaryElement
			implicitWidth: root.horizontalSize * 0.1
			implicitHeight: parent.height / 2


			Item {
				clip: true
				anchors {
					top: parent.top
					right: parent.right
					bottom: parent.bottom
				}
				width: parent.width / 1.2

				Rectangle {
					radius: width / 2
					anchors {
						top: parent.top
						right: parent.right
						bottom: parent.bottom
					}
					width: secondaryElement.width * 2
					color: root.bgColor
				}
			}
		}
	}

	StyledText {
		anchors {
			fill: parent
			rightMargin: secondaryElement.width
		}
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		font.pixelSize: 0.40 * root.horizontalSize
		color: root.textColor
		text: Math.round(root.percentage * 100)
	}
}
