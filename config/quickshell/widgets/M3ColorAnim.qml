import QtQuick
import qs.widgets

ColorAnimation {
	required property M3AnimData data

	duration: data.duration
	easing.type: Easing.BezierSpline
	easing.bezierCurve: data.curve
}
