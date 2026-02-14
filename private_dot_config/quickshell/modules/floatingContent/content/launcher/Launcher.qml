pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets
import qs.modules.floatingContent.content.launcher
import qs.config
import qs.utils
import qs.services

Item {
	id: root

	// Must be a QtObject due to a circular dependency issue
	required property Item wrapper

	property bool useGrid: Cache.launcher.useGrid
	function setUseGrid(useGrid: bool) {
		Cache.launcher.useGrid = useGrid
	}
	property string searchText: ""
	property list<DesktopEntry> apps: []

	implicitWidth: loader.implicitWidth
	implicitHeight: loader.implicitHeight

	Behavior on implicitHeight {
		M3NumberAnim {
			data: Anims.current.effects.regular
			duration: 0
			Component.onCompleted: Qt.callLater(() =>
				duration = Qt.binding(() => Anims.current.effects.regular.duration)
			)
		}
	}

	Behavior on implicitWidth {
		M3NumberAnim { data: Anims.current.effects.regular }
	}

	FadeLoader {
		id: loader
		anchors {
			top: parent.top
			horizontalCenter: parent.horizontalCenter
		}
		active: true
		sourceComponent: root.useGrid ? contentGrid : contentList
		animDur: Anims.current.effects.regular.duration
		easingType: Easing.BezierSpline
		bezierCurve: Anims.current.effects.regular.curve

		Connections {
			target: root

			function onUseGridChanged() {
				if (root.useGrid) {
					loader.setComp(contentGrid)
				} else {
					loader.setComp(contentList)
				}
			}
		}

		Component {
			id: contentList

			LauncherContentList {
				wrapper: root.wrapper
				launcher: root
			}
		}

		Component {
			id: contentGrid

			LauncherContentGrid {
				wrapper: root.wrapper
				launcher: root
			}
		}
	}
}
