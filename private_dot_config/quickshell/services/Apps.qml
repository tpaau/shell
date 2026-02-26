pragma Singleton

import "root:/scripts/fuzzysort.js" as Fuzzy
import Quickshell
import qs.utils

Singleton {
    id: root

    readonly property var list: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))
    readonly property var preppedApps: list.map(a => ({
		name: Fuzzy.prepare(a.name),
		comment: Fuzzy.prepare(a.comment),
		entry: a
	}))

    function fuzzyQuery(search: string): var {
        return Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "comment"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.entry);
    }

	function run(app: DesktopEntry): int {
		if (app) {
			if (app.runInTerminal) {
				Quickshell.execDetached({
					command: [Paths.termWrapScript, ...app.execString.split(" ")],
					workingDirectory: app.workingDirectory
				})
			}
			else {
				app.execute()
			}
			return 0
		}
		return 1
	}
}
