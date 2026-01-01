pragma Singleton

import "root:/scripts/fuzzysort.js" as Fuzzy
import Quickshell
import qs.config

Singleton {
    id: root

    readonly property list<DesktopEntry> list: DesktopEntries.applications.values.filter(a => !a.noDisplay).sort((a, b) => a.name.localeCompare(b.name))
    readonly property list<var> preppedApps: list.map(a => ({
		name: Fuzzy.prepare(a.name),
		comment: Fuzzy.prepare(a.comment),
		entry: a
	}))

    function fuzzyQuery(search: string): list<DesktopEntry> {
        return Fuzzy.go(search, preppedApps, {
            all: true,
            keys: ["name", "comment"],
            scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
        }).map(r => r.obj.entry);
    }

	function run(app: DesktopEntry): int {
		if (app) {
			if (app.runInTerminal) {
				let launchStr = `sh -c "${Config.preferences.terminalApp} ${app.execString}"`
				console.warn(launchStr)
				Quickshell.execDetached(launchStr)
			}
			else {
				app.execute()
			}
			return 0
		}
		return 1
	}
}
