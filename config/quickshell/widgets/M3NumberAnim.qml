import QtQuick
import qs.widgets

NumberAnimation {
	required property M3AnimData data

	duration: data.duration
	easing.type: Easing.BezierSpline
	easing.bezierCurve: data.curve
}
