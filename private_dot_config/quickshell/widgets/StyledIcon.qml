import QtQuick
import qs.config

Text {
    property real fill: 1

	readonly property real size: Math.max(width, height)

	color: Theme.palette.text
	font.family: "Material Symbols " + Config.icons.style
	font.weight: Config.font.weight.heavy
	font.pixelSize: Config.icons.size.regular
	font.hintingPreference: Font.PreferFullHinting
	renderType: Text.NativeRendering
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter

    font.variableAxes: ({
        FILL: fill.toFixed(1),
        // GRAD: grade,
        opsz: fontInfo.pixelSize,
        wght: fontInfo.weight
    })
}
