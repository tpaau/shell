import QtQuick
import qs.config

Text {
	property real fill: 1
	property real grade: 0

	readonly property real size: Math.max(width, height)

	renderType: Text.NativeRendering
	font.family: "Material Symbols " + Config.icons.style
	font.pixelSize: Config.icons.size.regular
	font.hintingPreference: Font.PreferFullHinting
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter
	color: Theme.palette.accent
	font.weight: Config.font.weight.heavy

	font.variableAxes: ({
			FILL: fill.toFixed(1),
			GRAD: grade,
			opsz: fontInfo.pixelSize,
			wght: fontInfo.weight
		})
}
