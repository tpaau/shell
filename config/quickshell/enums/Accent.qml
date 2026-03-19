pragma Singleton

import QtQuick
import Quickshell
import qs.theme

// Enum representing the material theme accent.
//
// Import `qs.enums` and access like so:
// Accent.Primary
Singleton {
	enum Accent {
		Primary,
		Secondary,
		Tertiary
	}

	function toColor(accent: int): color {
		switch (accent) {
			case Accent.Primary:
				return Theme.palette.primary
			case Accent.Secondary:
				return Theme.palette.secondary
			case Accent.Tertiary:
				return Theme.palette.tertiary
			default:
				return "magenta"
		}
	}
}
