import QtQuick
import qs.config
import qs.theme
import qs.utils // The linter is WRONG!!

Text {
	id: root

	enum Theme {
		Regular,
		RegularDim,
		Inverse,
		InverseDim
	}

	property bool mono: false
	property int theme: StyledText.Theme.Regular
	property real dimmedOpacity: 0.7
	property color regularColor: Theme.palette.on_surface
	property color inverseColor: Theme.palette.surface

	FontLoader {
		id: fontLoader
		source: root.mono ?
			`${Paths.fontsDir}NotoSansMono-VariableFont_wdth,wght.ttf`
			: `${Paths.fontsDir}/NotoSans-VariableFont_wdth,wght.ttf`
	}

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
	font.family: fontLoader.font.family
	font.pixelSize: Config.font.size.normal
	fontSizeMode: Text.FixedSize
}
