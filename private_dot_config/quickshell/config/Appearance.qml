pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: root

	readonly property QtObject rounding: Rounding {}
	readonly property Spacing spacing: Spacing {}
	readonly property Anims anims: Anims {}
	readonly property Borders borders: Borders {}
	readonly property Misc misc: Misc {}
	readonly property Shadows shadows: Shadows {}
	readonly property Icons icons: Icons {}

    component Rounding: QtObject {
		readonly property int smaller: 8
        readonly property int small: 12
        readonly property int normal: 15
        readonly property int large: 24

		readonly property int window: large
		readonly property int popout: large
    }

	component Spacing: QtObject {
		readonly property int smaller: 4
		readonly property int small: 8
		readonly property int normal: 12
        readonly property int large: 16
        readonly property int larger: 20
	}

	component AnimEasing: QtObject {
		readonly property int fade: Easing.InOutQuad
		readonly property int fadeIn: Easing.InQuad
		readonly property int fadeOut: Easing.OutQuad
		readonly property int popout: Easing.OutCubic
		readonly property int workspace: Easing.Linear
		readonly property int button: Easing.Linear
		readonly property int colorTransition: Easing.Linear
	}

	component AnimDurations: QtObject {
		readonly property int shorter: 100
		readonly property int shortish: 200
		readonly property int normal: 300
		readonly property int longish: 400
		readonly property int longer: 500

		readonly property int workspace: shortish
		readonly property int button: shorter
		readonly property int popout: shortish
		readonly property int notificationExpand: shortish
	}

	component Anims: QtObject {
		readonly property QtObject durations: AnimDurations {}
		readonly property QtObject easings: AnimEasing {}
	}

	component Borders: QtObject {
		readonly property int width: 2
		readonly property color color: Theme.pallete.bg.c3
		readonly property color brighterColor: Theme.pallete.fg.c3
	}

	component Misc: QtObject {
		readonly property int layerSampling: 4
		readonly property int statusBarHeight: 32
	}

	component Shadows: QtObject {
		readonly property int blur: 2
	}

	component Icons: QtObject {
		readonly property list<string> iconStyles: [
			"Rounded", "Sharp", "Outlined"
		]

		readonly property IconSize size: IconSize {}
		readonly property string style: iconStyles[0]
	}

	component IconSize: QtObject {
		readonly property int smaller: 16
		readonly property int small: 20
		readonly property int regular: 24
		readonly property int large: 28
		readonly property int larger: 32
	}
}
