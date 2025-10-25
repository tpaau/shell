import QtQuick.Shapes
import qs.widgets
import qs.config

Shape {
	layer.enabled: true
	layer.samples: Config.quality.layerSamples
	layer.effect: StyledShadow {}
}
