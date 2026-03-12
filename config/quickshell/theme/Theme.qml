pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils
import qs.config

Singleton {
	id: root

	readonly property QtObject palette: Config.theme.dark ? materialPalette.dark : materialPalette.light
	readonly property alias paletteDark: materialPalette.dark
	readonly property alias paletteLight: materialPalette.light

	function regenerateMatugen() {
		generator0.write()
		generator1.write()
		generator2.write()
		generator3.write()
	}

	component MatugenGenerator: Item {
		id: matugenGenerator

		required property int colorIndex
		required property string imagePath
		property bool writeOnChange: false

		function write() {
			writeProc.running = true
		}

		Process {
			id: writeProc
			command: [
				"matugen", "image",
				"--source-color-index",
				matugenGenerator.colorIndex,
				"-j", "rgb",
				"--lightness-light", Config.theme.matugenThemeLightnessLight,
				"--lightness-dark", Config.theme.matugenThemeLightnessDark,
				"--contrast", Utils.clamp(Config.theme.matugenThemeContrast, -1, 1),
				matugenGenerator.imagePath
			]
			onCommandChanged: if (matugenGenerator.writeOnChange) running = true
			stdout: StdioCollector {
				onStreamFinished: themeView.setText(text)
			}
		}

		FileView {
			id: themeView
			path: `${Paths.matugenThemesDir}/${matugenGenerator.colorIndex}.json`
		}
	}

	MatugenGenerator {
		id: generator0
		writeOnChange: true
		colorIndex: 0
		imagePath: Config.wallpaper.desktop
	}
	MatugenGenerator {
		id: generator1
		writeOnChange: true
		colorIndex: 1
		imagePath: Config.wallpaper.desktop
	}
	MatugenGenerator {
		id: generator2
		writeOnChange: true
		colorIndex: 2
		imagePath: Config.wallpaper.desktop
	}
	MatugenGenerator {
		id: generator3
		writeOnChange: true
		colorIndex: 3
		imagePath: Config.wallpaper.desktop
	}

	FileView {
		id: paletteFile
		path: Config.theme.path
		watchChanges: true
		onFileChanged: reload()
		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) root.regenerateMatugen()
		}

		JsonAdapter {
			id: themeAdapter

			property JsonObject base16: JsonObject {
				property JsonObject base00: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#1f110c" }
					property JsonObject light: JsonObject { property string color: "#56463e" }
				}
				property JsonObject base01: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#271813" }
					property JsonObject light: JsonObject { property string color: "#4e3e37" }
				}
				property JsonObject base02: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#2f201a" }
					property JsonObject light: JsonObject { property string color: "#473730" }
				}
				property JsonObject base03: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#372721" }
					property JsonObject light: JsonObject { property string color: "#3f2f29" }
				}
				property JsonObject base04: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#3f2f29" }
					property JsonObject light: JsonObject { property string color: "#372721" }
				}
				property JsonObject base05: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#473730" }
					property JsonObject light: JsonObject { property string color: "#2f201a" }
				}
				property JsonObject base06: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#4e3e37" }
					property JsonObject light: JsonObject { property string color: "#271813" }
				}
				property JsonObject base07: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#56463e" }
					property JsonObject light: JsonObject { property string color: "#1f110c" }
				}
				property JsonObject base08: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#56453e" }
					property JsonObject light: JsonObject { property string color: "#56453e" }
				}
				property JsonObject base09: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#3b2a25" }
					property JsonObject light: JsonObject { property string color: "#3b2a25" }
				}
				property JsonObject base0a: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#1f100b" }
					property JsonObject light: JsonObject { property string color: "#1f100b" }
				}
				property JsonObject base0b: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#2c3138" }
					property JsonObject light: JsonObject { property string color: "#2c3138" }
				}
				property JsonObject base0c: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#2a2f33" }
					property JsonObject light: JsonObject { property string color: "#2a2f33" }
				}
				property JsonObject base0d: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#2a2d31" }
					property JsonObject light: JsonObject { property string color: "#2a2d31" }
				}
				property JsonObject base0e: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#2a2d31" }
					property JsonObject light: JsonObject { property string color: "#2a2d31" }
				}
				property JsonObject base0f: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#2a2d31" }
					property JsonObject light: JsonObject { property string color: "#2a2d31" }
				}
			}
			property JsonObject colors: JsonObject {
				property JsonObject background: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#111318" }
					property JsonObject light: JsonObject { property string color: "#f9f9ff" }
				}
				property JsonObject error: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#ffb4ab" }
					property JsonObject light: JsonObject { property string color: "#ba1a1a" }
				}
				property JsonObject error_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#93000a" }
					property JsonObject light: JsonObject { property string color: "#ffdad6" }
				}
				property JsonObject inverse_on_surface: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#2e3035" }
					property JsonObject light: JsonObject { property string color: "#f0f0f7" }
				}
				property JsonObject inverse_primary: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#3e5f90" }
					property JsonObject light: JsonObject { property string color: "#a7c8ff" }
				}
				property JsonObject inverse_surface: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#e1e2e9" }
					property JsonObject light: JsonObject { property string color: "#2e3035" }
				}
				property JsonObject on_background: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#e1e2e9" }
					property JsonObject light: JsonObject { property string color: "#191c20" }
				}
				property JsonObject on_error: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#690005" }
					property JsonObject light: JsonObject { property string color: "#ffffff" }
				}
				property JsonObject on_error_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#ffdad6" }
					property JsonObject light: JsonObject { property string color: "#410002" }
				}
				property JsonObject on_primary: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#03305f" }
					property JsonObject light: JsonObject { property string color: "#ffffff" }
				}
				property JsonObject on_primary_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#d5e3ff" }
					property JsonObject light: JsonObject { property string color: "#001c3b" }
				}
				property JsonObject on_primary_fixed: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#001c3b" }
					property JsonObject light: JsonObject { property string color: "#001c3b" }
				}
				property JsonObject on_primary_fixed_variant: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#244777" }
					property JsonObject light: JsonObject { property string color: "#244777" }
				}
				property JsonObject on_secondary: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#273141" }
					property JsonObject light: JsonObject { property string color: "#ffffff" }
				}
				property JsonObject on_secondary_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#d9e3f8" }
					property JsonObject light: JsonObject { property string color: "#121c2b" }
				}
				property JsonObject on_secondary_fixed: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#121c2b" }
					property JsonObject light: JsonObject { property string color: "#121c2b" }
				}
				property JsonObject on_secondary_fixed_variant: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#3d4758" }
					property JsonObject light: JsonObject { property string color: "#3d4758" }
				}
				property JsonObject on_surface: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#e1e2e9" }
					property JsonObject light: JsonObject { property string color: "#191c20" }
				}
				property JsonObject on_surface_variant: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#c4c6cf" }
					property JsonObject light: JsonObject { property string color: "#43474e" }
				}
				property JsonObject on_tertiary: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#3e2845" }
					property JsonObject light: JsonObject { property string color: "#ffffff" }
				}
				property JsonObject on_tertiary_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#f8d8fe" }
					property JsonObject light: JsonObject { property string color: "#27132f" }
				}
				property JsonObject on_tertiary_fixed: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#27132f" }
					property JsonObject light: JsonObject { property string color: "#27132f" }
				}
				property JsonObject on_tertiary_fixed_variant: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#553e5d" }
					property JsonObject light: JsonObject { property string color: "#553e5d" }
				}
				property JsonObject outline: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#8e9199" }
					property JsonObject light: JsonObject { property string color: "#74777f" }
				}
				property JsonObject outline_variant: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#43474e" }
					property JsonObject light: JsonObject { property string color: "#c4c6cf" }
				}
				property JsonObject primary: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#a7c8ff" }
					property JsonObject light: JsonObject { property string color: "#3e5f90" }
				}
				property JsonObject primary_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#244777" }
					property JsonObject light: JsonObject { property string color: "#d5e3ff" }
				}
				property JsonObject primary_fixed: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#d5e3ff" }
					property JsonObject light: JsonObject { property string color: "#d5e3ff" }
				}
				property JsonObject primary_fixed_dim: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#a7c8ff" }
					property JsonObject light: JsonObject { property string color: "#a7c8ff" }
				}
				property JsonObject scrim: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#000000" }
					property JsonObject light: JsonObject { property string color: "#000000" }
				}
				property JsonObject secondary: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#bdc7dc" }
					property JsonObject light: JsonObject { property string color: "#555f71" }
				}
				property JsonObject secondary_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#3d4758" }
					property JsonObject light: JsonObject { property string color: "#d9e3f8" }
				}
				property JsonObject secondary_fixed: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#d9e3f8" }
					property JsonObject light: JsonObject { property string color: "#d9e3f8" }
				}
				property JsonObject secondary_fixed_dim: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#bdc7dc" }
					property JsonObject light: JsonObject { property string color: "#bdc7dc" }
				}
				property JsonObject shadow: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#000000" }
					property JsonObject light: JsonObject { property string color: "#000000" }
				}
				property JsonObject source_color: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#12161d" }
					property JsonObject light: JsonObject { property string color: "#12161d" }
				}
				property JsonObject surface: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#111318" }
					property JsonObject light: JsonObject { property string color: "#f9f9ff" }
				}
				property JsonObject surface_bright: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#37393e" }
					property JsonObject light: JsonObject { property string color: "#f9f9ff" }
				}
				property JsonObject surface_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#1d2024" }
					property JsonObject light: JsonObject { property string color: "#ededf4" }
				}
				property JsonObject surface_container_high: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#282a2f" }
					property JsonObject light: JsonObject { property string color: "#e7e8ee" }
				}
				property JsonObject surface_container_highest: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#32353a" }
					property JsonObject light: JsonObject { property string color: "#e1e2e9" }
				}
				property JsonObject surface_container_low: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#191c20" }
					property JsonObject light: JsonObject { property string color: "#f3f3fa" }
				}
				property JsonObject surface_container_lowest: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#0c0e13" }
					property JsonObject light: JsonObject { property string color: "#ffffff" }
				}
				property JsonObject surface_dim: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#111318" }
					property JsonObject light: JsonObject { property string color: "#d9dae0" }
				}
				property JsonObject surface_tint: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#a7c8ff" }
					property JsonObject light: JsonObject { property string color: "#3e5f90" }
				}
				property JsonObject surface_variant: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#43474e" }
					property JsonObject light: JsonObject { property string color: "#e0e2ec" }
				}
				property JsonObject tertiary: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#dbbde2" }
					property JsonObject light: JsonObject { property string color: "#6e5676" }
				}
				property JsonObject tertiary_container: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#553e5d" }
					property JsonObject light: JsonObject { property string color: "#f8d8fe" }
				}
				property JsonObject tertiary_fixed: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#f8d8fe" }
					property JsonObject light: JsonObject { property string color: "#f8d8fe" }
				}
				property JsonObject tertiary_fixed_dim: JsonObject {
					property JsonObject dark: JsonObject { property string color: "#dbbde2" }
					property JsonObject light: JsonObject { property string color: "#dbbde2" }
				}
			}
			property JsonObject palettes: JsonObject {
				property JsonObject error: JsonObject {
					property string _0: "#000000"
					property string _5: "#2d0001"
					property string _10: "#410002"
					property string _15: "#540003"
					property string _20: "#690005"
					property string _25: "#7e0007"
					property string _30: "#93000a"
					property string _35: "#a80710"
					property string _40: "#ba1a1a"
					property string _50: "#de3730"
					property string _60: "#ff5449"
					property string _70: "#ff897d"
					property string _80: "#ffb4ab"
					property string _90: "#ffdad6"
					property string _95: "#ffedea"
					property string _98: "#fff8f7"
					property string _99: "#fffbff"
					property string _100: "#ffffff"
				}
				property JsonObject neutral: JsonObject {
					property string _0: "#000000"
					property string _5: "#101114"
					property string _10: "#1a1c1e"
					property string _15: "#252629"
					property string _20: "#2f3033"
					property string _25: "#3a3b3e"
					property string _30: "#46474a"
					property string _35: "#515256"
					property string _40: "#5e5e62"
					property string _50: "#76777a"
					property string _60: "#909094"
					property string _70: "#ababae"
					property string _80: "#c7c6ca"
					property string _90: "#e3e2e6"
					property string _95: "#f1f0f4"
					property string _98: "#faf9fd"
					property string _99: "#fdfbff"
					property string _100: "#ffffff"
				}
				property JsonObject neutral_variant: JsonObject {
					property string _0: "#000000"
					property string _5: "#0d1117"
					property string _10: "#181c22"
					property string _15: "#22262d"
					property string _20: "#2d3038"
					property string _25: "#383b43"
					property string _30: "#43474e"
					property string _35: "#4f525a"
					property string _40: "#5b5e66"
					property string _50: "#74777f"
					property string _60: "#8e9199"
					property string _70: "#a8abb4"
					property string _80: "#c4c6cf"
					property string _90: "#e0e2ec"
					property string _95: "#eef0fa"
					property string _98: "#f9f9ff"
					property string _99: "#fdfbff"
					property string _100: "#ffffff"
				}
				property JsonObject primary: JsonObject {
					property string _0: "#000000"
					property string _5: "#001128"
					property string _10: "#001c3b"
					property string _15: "#00264d"
					property string _20: "#003060"
					property string _25: "#003b74"
					property string _30: "#004788"
					property string _35: "#0c5299"
					property string _40: "#225fa6"
					property string _50: "#4278c1"
					property string _60: "#5e92dd"
					property string _70: "#79adf9"
					property string _80: "#a7c8ff"
					property string _90: "#d5e3ff"
					property string _95: "#ebf1ff"
					property string _98: "#f9f9ff"
					property string _99: "#fdfbff"
					property string _100: "#ffffff"
				}
				property JsonObject secondary: JsonObject {
					property string _0: "#000000"
					property string _5: "#071120"
					property string _10: "#121c2b"
					property string _15: "#1c2636"
					property string _20: "#273141"
					property string _25: "#323c4d"
					property string _30: "#3d4758"
					property string _35: "#495364"
					property string _40: "#555f71"
					property string _50: "#6d778a"
					property string _60: "#8791a5"
					property string _70: "#a1acc0"
					property string _80: "#bdc7dc"
					property string _90: "#d9e3f8"
					property string _95: "#ebf1ff"
					property string _98: "#f9f9ff"
					property string _99: "#fdfbff"
					property string _100: "#ffffff"
				}
				property JsonObject tertiary: JsonObject {
					property string _0: "#000000"
					property string _5: "#1c0824"
					property string _10: "#27132f"
					property string _15: "#321e3a"
					property string _20: "#3e2845"
					property string _25: "#493351"
					property string _30: "#553e5d"
					property string _35: "#624a69"
					property string _40: "#6e5676"
					property string _50: "#886e8f"
					property string _60: "#a387aa"
					property string _70: "#bea2c5"
					property string _80: "#dbbde2"
					property string _90: "#f8d8fe"
					property string _95: "#feebff"
					property string _98: "#fff7fb"
					property string _99: "#fffbff"
					property string _100: "#ffffff"
				}
			}
		}
	}

	QtObject {
		id: materialPalette

		property QtObject light: QtObject {
			property color primary: themeAdapter.colors.primary.light.color
			property color on_primary: themeAdapter.colors.on_primary.light.color
			property color primary_container: themeAdapter.colors.primary_container.light.color
			property color on_primary_container: themeAdapter.colors.on_primary_container.light.color
			property color inverse_primary: themeAdapter.colors.inverse_primary.light.color
			property color primary_fixed: themeAdapter.colors.primary_fixed.light.color
			property color primary_fixed_dim: themeAdapter.colors.primary_fixed_dim.light.color
			property color on_primary_fixed: themeAdapter.colors.on_primary_fixed.light.color
			property color on_primary_fixed_variant: themeAdapter.colors.on_primary_fixed_variant.light.color
			property color secondary: themeAdapter.colors.secondary.light.color
			property color on_secondary: themeAdapter.colors.on_secondary.light.color
			property color secondary_container: themeAdapter.colors.secondary_container.light.color
			property color on_secondary_container: themeAdapter.colors.on_secondary_container.light.color
			property color secondary_fixed: themeAdapter.colors.secondary_fixed.light.color
			property color secondary_fixed_dim: themeAdapter.colors.secondary_fixed_dim.light.color
			property color on_secondary_fixed: themeAdapter.colors.on_secondary_fixed.light.color
			property color on_secondary_fixed_variant: themeAdapter.colors.on_secondary_fixed_variant.light.color
			property color tertiary: themeAdapter.colors.tertiary.light.color
			property color on_tertiary: themeAdapter.colors.on_tertiary.light.color
			property color tertiary_container: themeAdapter.colors.tertiary_container.light.color
			property color on_tertiary_container: themeAdapter.colors.on_tertiary_container.light.color
			property color tertiary_fixed: themeAdapter.colors.tertiary_fixed.light.color
			property color tertiary_fixed_dim: themeAdapter.colors.tertiary_fixed_dim.light.color
			property color on_tertiary_fixed: themeAdapter.colors.on_tertiary_fixed.light.color
			property color on_tertiary_fixed_variant: themeAdapter.colors.on_tertiary_fixed_variant.light.color
			property color error: themeAdapter.colors.error.light.color
			property color on_error: themeAdapter.colors.on_error.light.color
			property color error_container: themeAdapter.colors.error_container.light.color
			property color on_error_container: themeAdapter.colors.on_error_container.light.color
			property color surface_dim: themeAdapter.colors.surface_dim.light.color
			property color surface: themeAdapter.colors.surface.light.color
			property color surface_tint: themeAdapter.colors.surface_tint.light.color
			property color surface_bright: themeAdapter.colors.surface_bright.light.color
			property color surface_container_lowest: themeAdapter.colors.surface_container_lowest.light.color
			property color surface_container_low: themeAdapter.colors.surface_container_low.light.color
			property color surface_container: themeAdapter.colors.surface_container.light.color
			property color surface_container_high: themeAdapter.colors.surface_container_high.light.color
			property color surface_container_highest: themeAdapter.colors.surface_container_highest.light.color
			property color on_surface: themeAdapter.colors.on_surface.light.color
			property color on_surface_variant: themeAdapter.colors.on_surface_variant.light.color
			property color outline: themeAdapter.colors.outline.light.color
			property color outline_variant: themeAdapter.colors.outline_variant.light.color
			property color inverse_surface: themeAdapter.colors.inverse_surface.light.color
			property color inverse_on_surface: themeAdapter.colors.inverse_on_surface.light.color
			property color surface_variant: themeAdapter.colors.surface_variant.light.color
			property color background: themeAdapter.colors.background.light.color
			property color on_background: themeAdapter.colors.on_background.light.color
			property color shadow: themeAdapter.colors.shadow.light.color
			property color scrim: themeAdapter.colors.scrim.light.color
			property color source_color: themeAdapter.colors.source_color.light.color
			property color base00: themeAdapter.base16.base00.light.color
			property color base01: themeAdapter.base16.base01.light.color
			property color base02: themeAdapter.base16.base02.light.color
			property color base03: themeAdapter.base16.base03.light.color
			property color base04: themeAdapter.base16.base04.light.color
			property color base05: themeAdapter.base16.base05.light.color
			property color base06: themeAdapter.base16.base06.light.color
			property color base07: themeAdapter.base16.base07.light.color
			property color base08: themeAdapter.base16.base08.light.color
			property color base09: themeAdapter.base16.base09.light.color
			property color base0a: themeAdapter.base16.base0a.light.color
			property color base0b: themeAdapter.base16.base0b.light.color
			property color base0c: themeAdapter.base16.base0c.light.color
			property color base0d: themeAdapter.base16.base0d.light.color
			property color base0e: themeAdapter.base16.base0e.light.color
			property color base0f: themeAdapter.base16.base0f.light.color
		}
		property QtObject dark: QtObject {
			property color primary: themeAdapter.colors.primary.dark.color
			property color on_primary: themeAdapter.colors.on_primary.dark.color
			property color primary_container: themeAdapter.colors.primary_container.dark.color
			property color on_primary_container: themeAdapter.colors.on_primary_container.dark.color
			property color inverse_primary: themeAdapter.colors.inverse_primary.dark.color
			property color primary_fixed: themeAdapter.colors.primary_fixed.dark.color
			property color primary_fixed_dim: themeAdapter.colors.primary_fixed_dim.dark.color
			property color on_primary_fixed: themeAdapter.colors.on_primary_fixed.dark.color
			property color on_primary_fixed_variant: themeAdapter.colors.on_primary_fixed_variant.dark.color
			property color secondary: themeAdapter.colors.secondary.dark.color
			property color on_secondary: themeAdapter.colors.on_secondary.dark.color
			property color secondary_container: themeAdapter.colors.secondary_container.dark.color
			property color on_secondary_container: themeAdapter.colors.on_secondary_container.dark.color
			property color secondary_fixed: themeAdapter.colors.secondary_fixed.dark.color
			property color secondary_fixed_dim: themeAdapter.colors.secondary_fixed_dim.dark.color
			property color on_secondary_fixed: themeAdapter.colors.on_secondary_fixed.dark.color
			property color on_secondary_fixed_variant: themeAdapter.colors.on_secondary_fixed_variant.dark.color
			property color tertiary: themeAdapter.colors.tertiary.dark.color
			property color on_tertiary: themeAdapter.colors.on_tertiary.dark.color
			property color tertiary_container: themeAdapter.colors.tertiary_container.dark.color
			property color on_tertiary_container: themeAdapter.colors.on_tertiary_container.dark.color
			property color tertiary_fixed: themeAdapter.colors.tertiary_fixed.dark.color
			property color tertiary_fixed_dim: themeAdapter.colors.tertiary_fixed_dim.dark.color
			property color on_tertiary_fixed: themeAdapter.colors.on_tertiary_fixed.dark.color
			property color on_tertiary_fixed_variant: themeAdapter.colors.on_tertiary_fixed_variant.dark.color
			property color error: themeAdapter.colors.error.dark.color
			property color on_error: themeAdapter.colors.on_error.dark.color
			property color error_container: themeAdapter.colors.error_container.dark.color
			property color on_error_container: themeAdapter.colors.on_error_container.dark.color
			property color surface_dim: themeAdapter.colors.surface_dim.dark.color
			property color surface: themeAdapter.colors.surface.dark.color
			property color surface_tint: themeAdapter.colors.surface_tint.dark.color
			property color surface_bright: themeAdapter.colors.surface_bright.dark.color
			property color surface_container_lowest: themeAdapter.colors.surface_container_lowest.dark.color
			property color surface_container_low: themeAdapter.colors.surface_container_low.dark.color
			property color surface_container: themeAdapter.colors.surface_container.dark.color
			property color surface_container_high: themeAdapter.colors.surface_container_high.dark.color
			property color surface_container_highest: themeAdapter.colors.surface_container_highest.dark.color
			property color on_surface: themeAdapter.colors.on_surface.dark.color
			property color on_surface_variant: themeAdapter.colors.on_surface_variant.dark.color
			property color outline: themeAdapter.colors.outline.dark.color
			property color outline_variant: themeAdapter.colors.outline_variant.dark.color
			property color inverse_surface: themeAdapter.colors.inverse_surface.dark.color
			property color inverse_on_surface: themeAdapter.colors.inverse_on_surface.dark.color
			property color surface_variant: themeAdapter.colors.surface_variant.dark.color
			property color background: themeAdapter.colors.background.dark.color
			property color on_background: themeAdapter.colors.on_background.dark.color
			property color shadow: themeAdapter.colors.shadow.dark.color
			property color scrim: themeAdapter.colors.scrim.dark.color
			property color source_color: themeAdapter.colors.source_color.dark.color
			property color base00: themeAdapter.base16.base00.dark.color
			property color base01: themeAdapter.base16.base01.dark.color
			property color base02: themeAdapter.base16.base02.dark.color
			property color base03: themeAdapter.base16.base03.dark.color
			property color base04: themeAdapter.base16.base04.dark.color
			property color base05: themeAdapter.base16.base05.dark.color
			property color base06: themeAdapter.base16.base06.dark.color
			property color base07: themeAdapter.base16.base07.dark.color
			property color base08: themeAdapter.base16.base08.dark.color
			property color base09: themeAdapter.base16.base09.dark.color
			property color base0a: themeAdapter.base16.base0a.dark.color
			property color base0b: themeAdapter.base16.base0b.dark.color
			property color base0c: themeAdapter.base16.base0c.dark.color
			property color base0d: themeAdapter.base16.base0d.dark.color
			property color base0e: themeAdapter.base16.base0e.dark.color
			property color base0f: themeAdapter.base16.base0f.dark.color
		}
	}
}
