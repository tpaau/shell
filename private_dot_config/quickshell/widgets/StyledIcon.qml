import QtQuick
import qs.config

Text {
    property real fill

	color: Theme.palette.text
	font.family: "Material Symbols " + Config.icons.style
	font.weight: Config.font.weight.heavy
	font.pixelSize: Config.icons.size.regular
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter

    font.variableAxes: ({
        FILL: fill.toFixed(1),
        // GRAD: grade,
        opsz: fontInfo.pixelSize,
        wght: fontInfo.weight
    })
}
