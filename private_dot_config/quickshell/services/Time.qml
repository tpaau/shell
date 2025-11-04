pragma Singleton

import QtQuick
import Quickshell

Singleton {
	id: root

	property string date: clock.date

	function formatTimeElapsed(minutes: int): string {
		if (minutes == 0) {
			return "now"
		}
		else {
			let m = minutes
			let result = ""

			let d = Math.floor(m / 1440)
			if (d != 0) result += d + "d "
			m -= d * 1440

			let h = Math.floor(m / 60)
			if (h != 0 || d != 0) result += h + "h "
			m -= h * 60

			result += m + "m"

			return result
		}
	}

	SystemClock {
		id: clock
	}
}
