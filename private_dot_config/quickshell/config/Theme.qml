pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.config.palletes

Singleton {
	property Pallete pallete: blackAndWhite

	Pallete {
		id: blackAndWhite

		bg: PalletePart {
			c1: "#000000"
			c2: "#0D0D0D"
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
