import QtQuick
import qs.config

Text {
	color: Theme.pallete.fg.c4
	font.family: "Material Symbols " + Config.icons.style
	font.weight: Config.font.weight.heavy
	font.pixelSize: Config.icons.size.regular
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter

	// Funky results
	// font.variableAxes: {
	// 	"FILL": 1
	// }
}
