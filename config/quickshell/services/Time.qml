pragma Singleton

import QtQuick
import Quickshell

Singleton {
	id: root

	property date date: clock.date

	function formatTimeElapsed(minutes: int): string {
		if (minutes === 0) {
			return "now"
		}
		if (minutes < 60) {
			return `${minutes}m`
		}
		if (minutes < 1440) {
			return `${Math.floor(minutes / 60)}h`
		}
		else {
			return `${Math.floor(minutes / 1440)}d`
		}
	}

	SystemClock {
		id: clock
	}
}
