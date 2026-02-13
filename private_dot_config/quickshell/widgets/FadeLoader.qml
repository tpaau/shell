pragma ComponentBehavior: Bound

import QtQuick

Loader {
	id: root

	active: false
	layer.enabled: true

	property int animDur: 200
	property int easingType: Easing.Linear
	property list<real> bezierCurve: []
	property Component pendingComponent: null

	function setComp(comp: Component) {
		if (active) {
			pendingComponent = comp
			fadeOut.restart()
		} else {
			sourceComponent = comp
			fadeIn.restart()
			active = true
		}
	}

	function close() {
		pendingComponent = null
		fadeOut.restart()
	}

	component Anim: NumberAnimation {
		target: root
		property: "opacity"
		duration: root.animDur
		easing.type: root.easingType
		easing.bezierCurve: root.bezierCurve
	}

	Anim {
		id: fadeOut
		from: 1
		to: 0
		onFinished: if (root.pendingComponent) {
			root.sourceComponent = root.pendingComponent
			fadeIn.restart()
		} else {
			root.sourceComponent = null
			root.active = false
		}
	}

	Anim {
		id: fadeIn
		from: 0
		to: 1
	}
}
