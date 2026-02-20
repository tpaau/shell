import QtQuick.Effects
import qs.services.config

MultiEffect {
	shadowEnabled: true
	shadowColor: Theme.palette.shadow
	blurMax: Config.shadows.blur
}
