pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils

Singleton {
	id: root

	readonly property alias palette: materialPalette.dark
	readonly property alias desktopWallpaper: wallpapersAdapter.desktopWallpaper
	readonly property alias lockscreenWallpaper: wallpapersAdapter.lockscreenWallpaper
	readonly property alias overviewWallpaper: wallpapersAdapter.overviewWallpaper
	readonly property string desktopWallpaperDepthmap: desktopDepthWatcher.exists ?
		toDepthFilename(desktopWallpaper) : null

	function toDepthFilename(filename) {
		return filename.replace(/(\.[^.\/\\]+)?$/, (ext) => ext ? `_depth${ext}` : `_depth`)
	}

	// This one throws warnings if the depth file does not exists. Don't mind it.
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
			property string overviewWallpaper: Paths.wallpapersDir
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

	JsonObject {
		id: materialPalette

		property JsonObject light: JsonObject {
			property color primary: "#415F91"
			property color on_primary: "#FFFFFF"
			property color primary_container: "#D7E3FF"
			property color on_primary_container: "#001B3E"
			property color inverse_primary: "#AAC7FF"
			property color primary_fixed: "#D7E3FF"
			property color primary_fixed_dim: "#AAC7FF"
			property color on_primary_fixed: "#001B3E"
			property color on_primary_fixed_variant: "#284777"
			property color secondary: "#565E71"
			property color on_secondary: "#FFFFFF"
			property color secondary_container: "#DAE2F9"
			property color on_secondary_container: "#131C2B"
			property color secondary_fixed: "#DAE2F9"
			property color secondary_fixed_dim: "#BEC6DC"
			property color on_secondary_fixed: "#131C2B"
			property color on_secondary_fixed_variant: "#3E4759"
			property color tertiary: "#705574"
			property color on_tertiary: "#FFFFFF"
			property color tertiary_container: "#FAD8FD"
			property color on_tertiary_container: "#28132E"
			property color tertiary_fixed: "#FAD8FD"
			property color tertiary_fixed_dim: "#DDBCE0"
			property color on_tertiary_fixed: "#28132E"
			property color on_tertiary_fixed_variant: "#573E5C"
			property color error: "#BA1A1A"
			property color on_error: "#FFFFFF"
			property color error_container: "#FFDAD6"
			property color on_error_container: "#410002"
			property color surface_dim: "#D9D9E0"
			property color surface: "#F9F9FF"
			property color surface_tint: "#415F91"
			property color surface_bright: "#F9F9FF"
			property color surface_container_lowest: "#FFFFFF"
			property color surface_container_low: "#F3F3FA"
			property color surface_container: "#EDEDF4"
			property color surface_container_high: "#E7E8EE"
			property color surface_container_highest: "#E2E2E9"
			property color on_surface: "#191C20"
			property color on_surface_variant: "#44474E"
			property color outline: "#74777F"
			property color outline_variant: "#C4C6D0"
			property color inverse_surface: "#2E3036"
			property color inverse_on_surface: "#F0F0F7"
			property color surface_variant: "#E0E2EC"
			property color background: "#F9F9FF"
			property color on_background: "#191C20"
			property color shadow: "#000000"
			property color scrim: "#000000"
			property color source_color: "#3A76CE"
			property color base00: "#A9D2EF"
			property color base05: "#384654"
			property color base01: "#92B6D0"
			property color base02: "#7C9AB1"
			property color base03: "#657E92"
			property color base04: "#4F6273"
			property color base06: "#222A36"
			property color base07: "#0B0E17"
			property color base08: "#054B8C"
			property color base09: "#033F78"
			property color base0a: "#01386C"
			property color base0b: "#5387BE"
			property color base0c: "#00346A"
			property color base0d: "#2A5C90"
			property color base0e: "#013364"
			property color base0f: "#04305E"
		}

		property JsonObject dark: JsonObject {
			property color primary: "#AAC7FF"
			property color on_primary: "#0B305F"
			property color primary_container: "#284777"
			property color on_primary_container: "#D7E3FF"
			property color inverse_primary: "#415F91"
			property color primary_fixed: "#D7E3FF"
			property color primary_fixed_dim: "#AAC7FF"
			property color on_primary_fixed: "#001B3E"
			property color on_primary_fixed_variant: "#284777"
			property color secondary: "#BEC6DC"
			property color on_secondary: "#283141"
			property color secondary_container: "#3E4759"
			property color on_secondary_container: "#DAE2F9"
			property color secondary_fixed: "#DAE2F9"
			property color secondary_fixed_dim: "#BEC6DC"
			property color on_secondary_fixed: "#131C2B"
			property color on_secondary_fixed_variant: "#3E4759"
			property color tertiary: "#DDBCE0"
			property color on_tertiary: "#3F2844"
			property color tertiary_container: "#573E5C"
			property color on_tertiary_container: "#FAD8FD"
			property color tertiary_fixed: "#FAD8FD"
			property color tertiary_fixed_dim: "#DDBCE0"
			property color on_tertiary_fixed: "#28132E"
			property color on_tertiary_fixed_variant: "#573E5C"
			property color error: "#FFB4AB"
			property color on_error: "#690005"
			property color error_container: "#93000A"
			property color on_error_container: "#FFDAD6"
			property color surface_dim: "#111318"
			property color surface: "#111318"
			property color surface_tint: "#AAC7FF"
			property color surface_bright: "#37393E"
			property color surface_container_lowest: "#0C0E13"
			property color surface_container_low: "#191C20"
			property color surface_container: "#1E2025"
			property color surface_container_high: "#282A2F"
			property color surface_container_highest: "#33353A"
			property color on_surface: "#E2E2E9"
			property color on_surface_variant: "#C4C6D0"
			property color outline: "#8E9099"
			property color outline_variant: "#44474E"
			property color inverse_surface: "#E2E2E9"
			property color inverse_on_surface: "#2E3036"
			property color surface_variant: "#44474E"
			property color background: "#111318"
			property color on_background: "#E2E2E9"
			property color shadow: "#000000"
			property color scrim: "#000000"
			property color source_color: "#3A76CE"
			property color base00: "#0B0E17"
			property color base05: "#7C9AB1"
			property color base01: "#222A36"
			property color base02: "#384654"
			property color base03: "#4F6273"
			property color base04: "#657E92"
			property color base06: "#92B6D0"
			property color base07: "#A9D2EF"
			property color base08: "#054B8C"
			property color base09: "#033F78"
			property color base0a: "#01386C"
			property color base0b: "#5387BE"
			property color base0c: "#00346A"
			property color base0d: "#2A5C90"
			property color base0e: "#013364"
			property color base0f: "#04305E"
		}
	}
}
