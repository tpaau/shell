import QtQuick.Shapes
import qs.widgets
import qs.config

Shape {
	layer.enabled: true
	layer.samples: Appearance.misc.layerSampling
	layer.effect: StyledShadow {}
}
