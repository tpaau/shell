import Quickshell.Io
import qs.services.config

Process {
	id: proc
	stderr: StdioCollector {
		onStreamFinished: {
			if (Config.debug.processStderrForwarding && text) {
				console.warn(`${proc.command}: '${text}'`)
			}
		}
	}
}
