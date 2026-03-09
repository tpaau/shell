pragma Singleton

import QtQuick
import Quickshell
import qs.services.config
import qs.widgets

Singleton {
	id: anims

	readonly property QtObject current: Config.animations.expressive ?
		expressive : standard

	readonly property int workspaceSwitchDur: current.effects.regular.duration

	readonly property QtObject standard: QtObject {
		readonly property QtObject spatial: QtObject {
			readonly property QtObject fast: M3AnimData {
				duration: 350 * Config.animations.speedMultiplier
				curve: [0.27, 1.06, 0.18, 1, 1, 1]
			}
			readonly property QtObject regular: M3AnimData {
				duration: 500 * Config.animations.speedMultiplier
				curve: [0.27, 1.06, 0.18, 1, 1, 1]
			}
			readonly property QtObject slow: M3AnimData {
				duration: 750 * Config.animations.speedMultiplier
				curve: [0.27, 1.06, 0.18, 1, 1, 1]
			}
		}
		readonly property QtObject effects: QtObject {
			readonly property QtObject fast: M3AnimData {
				duration: 150 * Config.animations.speedMultiplier
				curve: [0.31, 0.94, 0.34, 1, 1, 1]
			}
			readonly property QtObject regular: M3AnimData {
				duration: 200 * Config.animations.speedMultiplier
				curve: [0.34, 0.80, 0.34, 1, 1, 1]
			}
			readonly property QtObject slow: M3AnimData {
				duration: 300 * Config.animations.speedMultiplier
				curve: [0.34, 0.88, 0.34, 1, 1, 1]
			}
		}
	}
	readonly property QtObject expressive: QtObject {
		readonly property QtObject spatial: QtObject {
			readonly property QtObject fast: M3AnimData {
				duration: 350 * Config.animations.speedMultiplier
				curve: [0.42, 1.67, 0.21, 0.9, 1, 1]
			}
			readonly property QtObject regular: M3AnimData {
				duration: 500 * Config.animations.speedMultiplier
				curve: [0.38, 1.21, 0.22, 1, 1, 1]
			}
			readonly property QtObject slow: M3AnimData {
				duration: 650 * Config.animations.speedMultiplier
				curve: [0.39, 1.29, 0.35, 0.98, 1, 1]
			}
		}
		readonly property QtObject effects: QtObject {
			readonly property QtObject fast: M3AnimData {
				duration: 150 * Config.animations.speedMultiplier
				curve: [0.31, 0.94, 0.34, 1, 1, 1]
			}
			readonly property QtObject regular: M3AnimData {
				duration: 200 * Config.animations.speedMultiplier
				curve: [0.34, 0.80, 0.34, 1, 1, 1]
			}
			readonly property QtObject slow: M3AnimData {
				duration: 300 * Config.animations.speedMultiplier
				curve: [0.34, 0.88, 0.34, 1, 1, 1]
			}
		}
	}
}
