pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	property alias palette: adapter.palette

	FileView {
		path: Paths.themesDir + "/" + Config.theme.name + ".json"
		watchChanges: true
		onFileChanged: reload()
		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) writeAdapter()
		}

		JsonAdapter {
			id: adapter

			property JsonObject palette: JsonObject {
				property color background: "#000000"
				property color surface: "#1a1a1a"
				property color surfaceBright: "#282828"
				property color buttonDarkDisabled: surface
				property color buttonDarkRegular: surfaceBright
				property color buttonDarkHovered: buttonDisabled
				property color buttonDarkPressed: buttonRegular
				property color buttonDisabled: "#323232"
				property color buttonRegular: "#3a3a3a"
				property color buttonHovered: "#444444"
				property color buttonPressed: "#505050"
				property color buttonBrightDisabled: buttonDisabled
				property color buttonBrightRegular: accent
				property color buttonBrightHovered: accentDark
				property color buttonBrightPressed: accentDarker
				property color text: "#c6c6c6"
				property color textDim: "#b7b7b7"
				property color textIntense: "#e9e9e9"
				property color textInverted: "#1a1a1a"
				property color textInvertedDim: "#222222"
				property color accentDarker: "#999999"
				property color accentDark: "#b7b7b7"
				property color accent: "#c6c6c6"
				property color accentBright: "#e4e4e4"
				property color accentBrighter: "#ffffff"
				property color shadow: accentBright
				property color slider: accent
				property color sliderBackground: buttonDisabled
				property color sliderDisabled: sliderBackground
				property color sliderPressed: accentBright
				property color workspaceFocused: accentBrighter
				property color workspaceUnfocused: accentDarker
				property color workspaceInactive: buttonDarkPressed
			}
		}
	}
}
