import QtQuick
import QtQuick.Effects
import qs.theme

MultiEffect {
	shadowEnabled: true
	shadowColor: Qt.alpha(Theme.palette.shadow, strength)
	property real strength: 0.7
}
