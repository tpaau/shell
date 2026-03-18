pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.utils
import "root:/scripts/fuzzysort.js" as Fuzzy

Singleton {
    id: root

	readonly property var list: {
		return DesktopEntries.applications.values
		.filter(a => !a.noDisplay)
		.sort((a, b) => {
			const aFav = appMetaList.find(app => app.index == a.id)?.favourite ?? false
			const bFav = appMetaList.find(app => app.index == b.id)?.favourite ?? false
			if (aFav !== bFav) return aFav ? -1 : 1
			return a.name.localeCompare(b.name)
		})
	}
	onListChanged: favAppsState.write(list)
    readonly property var preppedApps: list.map(a => ({
		name: Fuzzy.prepare(a.name),
		comment: Fuzzy.prepare(a.comment),
		favourite: appMetaList.find(app => app.index == a.id)?.favourite ?? false,
		entry: a
	}))
	property bool firstChange: true
	property list<AppMeta> appMetaList: []

	function fuzzyQuery(search: string): var {
		const favBoost = 0.15

		const results = Fuzzy.go(search, preppedApps, {
			all: true,
			keys: ["name", "comment"],
			scoreFn: r => r[0].score > 0 ? r[0].score * 0.9 + r[1].score * 0.1 : 0
		})

		results.forEach(r => {
			const isFav = r.obj.favourite === true
			r.adjustedScore = r.score + (isFav ? favBoost : 0)
		})

		results.sort((a, b) => {
			if (b.adjustedScore !== a.adjustedScore) return b.adjustedScore - a.adjustedScore
			return a.obj.entry.name.localeCompare(b.obj.entry.name)
		})

		return results.map(r => r.obj.entry)
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

	function saveMetaState() {
		favAppsState.writeMeta(appMetaList)
	}

	// Load the desktop entries immediately
	function dummyInit() {}

	Component {
		id: appMeta
		AppMeta {}
	}

	// Speed up cold start by disabling writes while the desktop entries are still loading
	Timer {
		interval: 1000
		running: true
		onTriggered: favAppsState.ready = true
	}

	FileView {
		id: favAppsState
		path: Paths.favouriteAppsFile
		onFileChanged: reload()
		watchChanges: true

		property bool ready: false
		property bool loaded: false

		onLoaded: {
			const data = favAppsState.text()
			let meta = JSON.parse(data).map((app) => {
				return appMeta.createObject(root, {
					"index": app.index,
					"favourite": app.favourite,
				})
			})
			root.appMetaList = meta
			loaded = true
			console.debug("App metadata loaded.")
		}

		onLoadFailed: (err) => {
			if (err === FileViewError.FileNotFound) setText("{}")
		}

		function metaToJSON(meta: AppMeta): var {
			return {
				"index": meta.index,
				"favourite": meta.favourite,
			}
		}

		function metaListToJSON(apps: list<AppMeta>): var {
			return JSON.stringify(apps.map(
				(meta) => metaToJSON(meta)), null, 2
			)
		}

		function write(apps: list<DesktopEntry>) {
			if (!ready) return
			if (!loaded) return
			const prevValues = root.appMetaList
			let newValues = []
			for (const app of apps) {
				let newApp = appMeta.createObject(root)
				newApp.index = app.id
				const oldApp = prevValues.find(a => a.index == newApp.index)
				if (oldApp) {
					newApp.favourite = oldApp.favourite
				}
				newValues.push(newApp)
			}
			setText(metaListToJSON(newValues))
		}

		function writeMeta(meta: list<AppMeta>) {
			setText(metaListToJSON(meta))
		}
	}
}
