pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string socketPath: Quickshell.env("NIRI_SOCKET")

	property list<Workspace> workspaces: []
	property Workspace focusedWorkspace: null
	property list<NiriWindow> windows: []
	property NiriWindow focusedWindow: null
	property bool overviewOpened: false

	Component {
		id: workspaceComp
		Workspace { }
	}
	Component {
		id: windowComp
		NiriWindow { }
	}

	function screenshotWindow() {
		Quickshell.execDetached(["niri", "msg", "action", "screenshot-window"])
	}

	function closeAllWindows() {
		for (const window of windows) {
			console.warn(window.windowId)
			Quickshell.execDetached(["kill", window.pid.toString()])
		}
	}

    function activateWorkspace(id: int) {
        send({
            Action: {
                FocusWorkspace: {
                    reference: {
                        Id: id
                    }
                }
            }
        })
    }

    function send(request) {
        requestSocket.write(JSON.stringify(request) + "\n");
    }

    Socket {
        id: eventStreamSocket
        path: root.socketPath
        connected: true

        onConnectionStateChanged: {
            write('"EventStream"\n');
        }

		parser: SplitParser {
			onRead: line => {
				const event = JSON.parse(line)

				if (event.WorkspacesChanged) {
					let workspaces = []
					for (const workspace of event.WorkspacesChanged.workspaces) {
						const ws = workspaceComp.createObject(null, {
							workspaceId: workspace.id,
							idx: workspace.idx,
							name: workspace.name,
							output: workspace.output,
							isUrgent: workspace.is_urgent,
							isActive: workspace.is_active,
							isFocused: workspace.is_focused,
							activeWindowID: workspace.active_window_id
								? workspace.active_window_id : 0
						})
						if (ws.isFocused) {
							root.focusedWorkspace = ws
						}
						workspaces.push(ws)
					}
					workspaces = workspaces.sort((a, b) => a.workspaceId - b.workspaceId)
					root.workspaces = workspaces
				}
				else if (event.WorkspaceActivated) {
					const workspace = root.workspaces[event.WorkspaceActivated.id - 1]
					if (root.focusedWorkspace) {
						root.focusedWorkspace.isFocused = false
					}
					workspace.isFocused = true
					root.focusedWorkspace = workspace
				}
				else if (event.OverviewOpenedOrClosed) {
					root.overviewOpened = event.OverviewOpenedOrClosed.is_open
				}
				else if (event.WindowsChanged) {
					for (let workspace of root.workspaces) {
						workspace.containsWindow = false
					}
					const windows = event.WindowsChanged.windows
					let windowsList = []
					for (const win of windows) {
						const w = windowComp.createObject(null, {
							windowId: win.id,
							title: win.title,
							appId: win.app_id,
							pid: win.pid,
							workspaceId: win.workspace_id,
							isFocused: win.is_focused,
							isFloating: win.is_floating,
							isUrgent: win.is_urgent
						})
						windowsList.push(w)
						root.workspaces[w.workspaceId - 1].containsWindow = true
						if (w.isFocused) {
							root.focusedWindow = w
						}
					}
					root.windows = windowsList
				}
				else if (event.WindowOpenedOrChanged) {
					const win = event.WindowOpenedOrChanged.window
					let changedWinId = -1
					for (let i = 0; i < root.windows.length; i++) {
						if (root.windows[i].id == win.id) {
							changedWinId = i
							break
						}
					}
					const w = windowComp.createObject(null, {
						windowId: win.id,
						title: win.title,
						appId: win.app_id,
						pid: win.pid,
						workspaceId: win.workspace_id,
						isFocused: win.is_focused,
						isFloating: win.is_floating,
						isUrgent: win.is_urgent
					})
					if (changedWinId >= 0) {
						root.windows[changedWinId] = w
					}
					else {
						root.workspaces[w.workspaceId - 1].containsWindow = true
						root.windows.push(w)
					}
				}
				else if (event.WindowClosed) {
					const id = event.WindowClosed.id
					let windows = []
					for (let workspace of root.workspaces) {
						workspace.containsWindow = false
					}
					for (const window of root.windows) {
						if (window.windowId != id) {
							windows.push(window)
							root.workspaces[window.workspaceId - 1].containsWindow = true
						}
					}
					root.windows = windows
				}
				else if (event.WindowFocusChanged) {
					const id = event.WindowFocusChanged.id
					if (root.focusedWindow) {
						root.focusedWindow.isFocused = false
					}
					for (let win of root.windows) {
						if (win.id == id) {
							win.isFocused = true
							root.focusedWindow = win
							return
						}
					}
					root.windowsChanged()
				}
			}
		}
    }

    Socket {
        id: requestSocket
        path: root.socketPath
        connected: true
    }
}
