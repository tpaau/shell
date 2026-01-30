pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam
import qs.services
import qs.components.sessionLock

Item {
	id: root

	property bool locked: false

	readonly property string warningStr: "\x1b[1mYou should use the `lock-screen.sh` script or call `qs ipc call sessionLock secureLock` instead of manually locking the session, as you might end up with an unlocked session if the Quickshell lock fails!\x1b[0m"

	IpcHandler {
		target: "sessionLock"

		function unsafeLock(): string {
			loader.active = true
			return root.locked ? "OK\n" + root.warningStr : "Err\n" + root.warningStr
		}

		function secureLock() {
			Session.lock()
		}

		readonly property bool isLocked: root.locked
	}

	Loader {
		id: loader

		active: false
		onActiveChanged: if (!active)
			root.locked = false

		sourceComponent: Item {
			Component.onCompleted: root.locked = lock.locked

			Scope {
				id: lockContext

				// These properties are in the lockContext and not individual
				// lock surfaces, so all surfaces can share the same state.
				property string currentText: ""
				property bool unlockInProgress: false
				property bool showFailure: false

				onCurrentTextChanged: showFailure = false

				function tryUnlock() {
					if (currentText === "")
						return
					lockContext.unlockInProgress = true
					pam.start()
				}

				PamContext {
					id: pam

					configDirectory: Quickshell.shellDir + "/pam"
					config: "password.conf"

					onPamMessage: if (responseRequired) {
						respond(lockContext.currentText)
					}

					onCompleted: result => {
						if (result === PamResult.Success) {
							lock.locked = false
							root.locked = false
							loader.active = false
						} else {
							lockContext.currentText = ""
							lockContext.showFailure = true
						}
						lockContext.unlockInProgress = false
					}
				}
			}

			LockSurface {
				id: lock
				lockContext: lockContext
			}
		}
	}
}
