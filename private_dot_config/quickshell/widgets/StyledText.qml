import QtQuick
import qs.services.config

Text {
	color: Theme.palette.text
	font.weight: Config.font.weight.regular
	font.family: Config.font.family.regular
	font.pixelSize: Config.font.size.normal
	fontSizeMode: Text.FixedSize
}
