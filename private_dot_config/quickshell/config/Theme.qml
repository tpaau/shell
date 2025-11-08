pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config.palletes
import qs.utils

Singleton {
	property Pallete pallete: blackAndWhite
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
				property color surfaceRegular: "#1a1a1a"
				property color surfaceBright: "#222222"
				property color buttonDarkDisabled: surfaceRegular
				property color buttonDarkRegular: surfaceBright
				property color buttonDarkHovered: buttonDisabled
				property color buttonDarkPressed: buttonRegular
				property color buttonDisabled: "#323232"
				property color buttonRegular: "#3a3a3a"
				property color buttonHovered: "#444444"
				property color buttonPressed: "#505050"
				property color buttonBrightDisabled: accentDarker
				property color buttonBrightRegular: accent
				property color buttonBrightHovered: accentBright
				property color buttonBrightPressed: accentBrighter
				property color text: "#c6c6c6"
				property color textDim: "#b0b0b0"
				property color textInverted: surfaceRegular
				property color textInvertedDim: surfaceBright
				property color accentDarker: "#999999"
				property color accentDark: "#b7b7b7"
				property color accent: "#c6c6c6"
				property color accentBright: "#e4e4e4"
				property color accentBrighter: "#ffffff"
				property color shadow: accentBright
				property color slider: buttonRegular
				property color sliderPressed: buttonHovered
				property color sliderBright: accent
				property color sliderBrightPressed: accentBright
			}
		}
	}

	Pallete {
		id: blackAndWhite

		bg: PalletePart {
			c1: "#000000"
			c2: "#131313"
			c3: "#1B1B1B"
			c4: "#292929"
			c5: "#373737"
			c6: "#454545"
			c7: "#3F3F3F"
			c8: "#666666"
		}

		fg: PalletePart {
			c1: "#999999"
			c2: "#A8A8A8"
			c3: "#B7B7B7"
			c4: "#C6C6C6"
			c5: "#D5D5D5"
			c6: "#E4E4E4"
			c7: "#F3F3F3"
			c8: "#FFFFFF"
		}

		shadow: fg.c5
	}

	Pallete {
		id: purpleAndPink

		bg: PalletePart {
			c1: "#0a0a0b"
			c2: "#16151a"
			c3: "#211d27"
			c4: "#2d2433"
			c5: "#3c2b3e"
			c6: "#4b3248"
			c7: "#5c3851"
			c8: "#6e3f58"
		}

		fg: PalletePart {
			c1: "#997b9b"
			c2: "#a185a2"
			c3: "#a88fa9"
			c4: "#b099b1"
			c5: "#b7a4b8"
			c6: "#bfaebf"
			c7: "#c6b8c7"
			c8: "#cec3ce"
		}

		shadow: fg.c5
	}
}
