import QtQuick
import qs.services.config
import qs.services.config.theme

Text {
	enum Theme {
		Regular,
		RegularDim,
		Inverse,
		InverseDim
	}

	property real dimmedOpacity: 0.7
	property color regularColor: Theme.palette.on_surface
	property color inverseColor: Theme.palette.surface
	property int theme: StyledText.Theme.Regular

	color: switch (theme) {
		case StyledText.Theme.Regular:
			return regularColor
		case StyledText.Theme.RegularDim:
			return Qt.alpha(regularColor, dimmedOpacity)
		case StyledText.Theme.Inverse:
			return inverseColor
		case StyledText.Theme.InverseDim:
			return Qt.alpha(inverseColor, dimmedOpacity)
	}
	font.weight: Config.font.weight.regular
	font.family: Config.font.family.regular
	font.pixelSize: Config.font.size.normal
	fontSizeMode: Text.FixedSize
}
