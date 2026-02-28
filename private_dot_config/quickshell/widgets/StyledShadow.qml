import QtQuick.Effects
import qs.services.config
import qs.services.config.theme

MultiEffect {
	shadowEnabled: true
	shadowColor: Theme.palette.shadow
	blurMax: Config.shadows.blur
}
