import Quickshell.Io
import qs.config

Process {
	id: proc
	stderr: StdioCollector {
		onStreamFinished: {
			if (Config.debug.processStderrForwarding
			&& text && text != "") {
				console.warn(`${proc.command}: '${text}'`)
			}
		}
	}
}
