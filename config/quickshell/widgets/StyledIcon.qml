import QtQuick
import qs.config
import qs.theme

Text {
	enum Theme {
		Regular,
		RegularDim,
		Inverse,
		InverseDim
	}

	property color regularColor: Theme.palette.on_surface
	property color inverseColor: Theme.palette.surface
    property real fill: 1.0
	property real grade: 0.0
	property real dimmedOpacity: 0.7
	property int theme: StyledText.Theme.Regular

	readonly property real size: Math.max(width, height)

	renderType: Text.NativeRendering
	font.family: "Material Symbols " + Config.icons.style
	font.pixelSize: Config.icons.size.regular
	font.hintingPreference: Font.PreferFullHinting
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter
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

    font.variableAxes: ({
        FILL: fill.toFixed(1),
        GRAD: grade,
        opsz: fontInfo.pixelSize,
        wght: fontInfo.weight
    })
}
