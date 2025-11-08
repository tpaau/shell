import QtQuick.Effects
import qs.config

MultiEffect {
	shadowEnabled: true
	shadowColor: Theme.palette.shadow
	blurMax: Config.shadows.blur
}
