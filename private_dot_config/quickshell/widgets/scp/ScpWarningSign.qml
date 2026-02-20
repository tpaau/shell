import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.services.config

Rectangle {
	id: root

	readonly property int spacing: Config.spacing.normal

	required property string imageSource
	required property string dangerTitle
	required property string description

	color: Theme.palette.surface
	radius: spacing

	MarginWrapperManager { margin: 0 }

	ColumnLayout {
		spacing: 0

		Rectangle {
			color: "#ffffff"

			implicitWidth: parent.width
			implicitHeight: dangerSign.height

			topRightRadius: root.spacing
			topLeftRadius: root.spacing

			StyledText {
				id: dangerSign
				anchors.centerIn: parent
				text: "DANGER"
				font.weight: Config.font.weight.heavy
				font.pixelSize: Config.font.size.larger
				color: "#000000"
			}
		}

			Item {
				MarginWrapperManager { margin: root.spacing }

				RowLayout {
					spacing: root.spacing
					ColumnLayout {
						id: leftLayout

						IconImage {
							Layout.alignment: Qt.AlignCenter
							source: root.imageSource
							mipmap: true
							implicitSize: 70
						}

						StyledText {
							Layout.alignment: Qt.AlignCenter
							color: "#ffffff"
							font.pixelSize: Config.font.size.small
							text: root.dangerTitle
						}
					}

					ColumnLayout {
						spacing: root.spacing

						StyledText {
							text: root.description
							Layout.preferredWidth: 2 * leftLayout.width
							wrapMode: Text.WordWrap
						}
						ScpLogo {}
					}
				}
			}
	}
}
