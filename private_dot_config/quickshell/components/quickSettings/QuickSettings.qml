pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.widgets.mediaControl
import qs.animations
import qs.widgets.popout
import qs.config

LazyLoader {
	id: root

	property int radius: Appearance.rounding.popout

	property bool shouldClose: false
	function open() {
		shouldClose = false
		loading = true
	}

	function close() {
		shouldClose = true
	}

	PanelWindow {
		anchors.top: true
		exclusionMode: ExclusionMode.Ignore
		color: "transparent"

		implicitWidth: container.implicitWidth + 4 * root.radius
		implicitHeight: container.height
			+ Appearance.misc.statusBarHeight
			+ Appearance.shadows.blur
			+ 2 * container.spacing

		StyledPopoutShape {
			id: shape

			anchors {
				left: parent.left
				right: parent.right
				top: parent.top
				topMargin: Appearance.misc.statusBarHeight
			}

			height: 0
			Component.onCompleted: {
				height = Qt.binding(function() {
					return root.shouldClose ?
						0 : container.height + 2 * container.spacing
				})
			}
			onHeightChanged: if (height <= 0) root.active = false

			Behavior on height {
				PopoutAnimation {}
			}

			layer.enabled: true
			layer.samples: Appearance.misc.layerSampling
			layer.effect: StyledShadow {
				autoPaddingEnabled: false
				paddingRect: Qt.rect(
					0,
					0,
					parent.width,
					parent.height)
			}

			TopPopoutShape {
				width: shape.width
				height: shape.height 
				radius: Appearance.rounding.popout
			}

			RowLayout {
				id: container
				spacing: root.radius

				anchors {
					left: parent.left
					right: parent.right
					bottom: parent.bottom
					leftMargin: 2 * root.radius
					rightMargin: 2 * root.radius
					bottomMargin: root.radius
				}

				MediaControl {}

				ColumnLayout {
					id: grid
					Layout.alignment: Qt.AlignTop
					Layout.preferredHeight: parent.height
					spacing: root.radius

					GridLayout {
						columns: 2
						rowSpacing: root.radius
						columnSpacing: rowSpacing
						Layout.alignment: Qt.AlignTop

						QSBluetoothButton {}
						CaffeineButton {}
					}

					RowLayout {
						Layout.alignment: Qt.AlignBottom
						Layout.preferredWidth: parent.width

						ActionButtons {
							id: actionButtons
							Layout.alignment: Qt.AlignRight
						}
					}
				}

			}

			MouseArea {
				anchors.fill: container
				propagateComposedEvents: true
				onPressed: (mouse) => {
					mouse.accepted = false
					actionButtons.closeDialogs()
				}
			}
		}

		HoverHandler {
			onHoveredChanged: if (!hovered) root.close()
		}
	}
}
