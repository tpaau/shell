pragma Singleton

import Quickshell

Singleton {
	function formatHMS(seconds: int): string {
        if (seconds < 0)
            return "-1:-1";

        const hours = Math.floor(seconds / 3600);
        const mins = Math.floor((seconds % 3600) / 60);
        const secs = Math.floor(seconds % 60).toString().padStart(2, "0");

        if (hours > 0)
            return `${hours}:${mins.toString().padStart(2, "0")}:${secs}`;
        return `${mins}:${secs}`;
	}

	function clamp(num: real, min: real, max: real): real {
		return Math.min(Math.max(num, min), max)
	}
}
