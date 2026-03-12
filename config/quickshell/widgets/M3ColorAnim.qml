import QtQuick
import qs.config

ColorAnimation {
	required property M3AnimData data

	duration: data.duration
	easing.type: Easing.BezierSpline
	easing.bezierCurve: data.curve
}
