pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	property alias palette: themeAdapter.palette
	property alias desktopWallpaper: wallpapersAdapter.desktopWallpaper
	property alias lockscreenWallpaper: wallpapersAdapter.lockscreenWallpaper
	property string desktopWallpaperDepthmap: desktopDepthWatcher.exists ?
		toDepthFilename(desktopWallpaper) : null

	function toDepthFilename(filename) {
		return filename.replace(/(\.[^.\/\\]+)?$/, (ext) => ext ? `_depth${ext}` : `_depth`)
	}

	FileView {
		id: desktopDepthWatcher
		path: root.toDepthFilename(root.desktopWallpaper)
		watchChanges: true
		property bool exists: false
		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) exists = false
		}
		onLoaded: exists = true
	}

	FileView {
		path: Paths.wallpapersCacheFile
		watchChanges: true
		onFileChanged: reload()
		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) writeAdapter()
		}

		JsonAdapter {
			id: wallpapersAdapter

			// If set to true, changing the theme will not change the current
			// wallpapers.
			property bool locked: false

			property string desktopWallpaper: Paths.wallpapersDir
				+ "/overlord-wallpaper.png"
			property string lockscreenWallpaper: Paths.wallpapersDir
				+ "/overlord-wallpaper.png"
		}
	}

	FileView {
		path: Paths.themesDir + "/" + Config.theme.name + ".json"
		watchChanges: true
		onFileChanged: reload()
		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) writeAdapter()
		}

		JsonAdapter {
			id: themeAdapter

			property string defaultDesktopWallpaper: ""
			property string defaultLockscreenWallpaper: ""

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
				property color textSelected: textInverted
				property color textInvertedSelected: text
				property color accentDarker: "#999999"
				property color accentDark: "#b7b7b7"
				property color accent: "#c6c6c6"
				property color accentBright: "#e4e4e4"
				property color accentBrighter: "#ffffff"
				property color shadow: accentBright
				property color slider: accent
				property color sliderBackground: buttonDisabled
				property color sliderDisabled: accentDarker
				property color sliderPressed: accentBright
				property color workspaceFocused: accentBrighter
				property color workspaceUnfocused: accentDarker
				property color workspaceInactive: buttonDarkPressed
			}
		}
	}
}
