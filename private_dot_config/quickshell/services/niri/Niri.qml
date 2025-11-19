// Since Quickshell doesn't have an API for Niri, only for I3 and Hyprland, I
// had to create my own. This one does not yet have multi-monitor support,
// although I'm working on it.
//
// I tried to document things and put comments where it makes sense, I also
// made several widgets that take advantage of this service, notably
// `OverviewButtons` and `NiriWorkspaces`.

pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property string socketPath: Quickshell.env("NIRI_SOCKET")

	// All the Niri workspaces.
	property list<Workspace> workspaces: []

	// The currently focused workspace.
	property Workspace focusedWorkspace: null

	// All the windows registered in Niri.
	property list<NiriWindow> windows: []

	// The currently focused window.
	property NiriWindow focusedWindow: null

	// Whether the overview mode is currently active. Setting this value does
	// nothing.
	property bool overviewOpened: false

	// Screenshots the current window. That one doesn't use the Quickshell
	// socket, sorry.
	function screenshotWindow() {
		Quickshell.execDetached(["niri", "msg", "action", "screenshot-window"])
	}

	// Toggles the overview mode.
	function toggleOverview() {
		send({
			Action: {
				ToggleOverview: {}
			}
		})
	}

	// Kills all windows registered by Niri.
	function closeAllWindows() {
		for (const window of windows) {
			Quickshell.execDetached(["kill", window.pid.toString()])
		}
	}

	// Activates the workspace with the given ID.
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

	Component {
		id: workspaceComp
		Workspace {}
	}

	Component {
		id: windowComp
		NiriWindow {}
	}

	// This socket is for sending requests to Niri.
    Socket {
        id: requestSocket
        path: root.socketPath
        connected: true
    }

	// And this one is for receiving events from Niri.
    Socket {
        path: root.socketPath
        connected: true

		// Request Niri to stream the events.
        onConnectionStateChanged: {
            write('"EventStream"\n');
        }

		parser: SplitParser {
			onRead: line => {
				const event = JSON.parse(line)

				if (event.OverviewOpenedOrClosed) {
					console.info(`NiriService: Overview toggled: ${event.OverviewOpenedOrClosed.is_open}`)
					root.overviewOpened = event.OverviewOpenedOrClosed.is_open
					return
				}
				else if (event.WorkspacesChanged) {
					console.info(`NiriService: Workspaces changed`)
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
								? workspace.active_window_id : -1
						})
						if (ws.isFocused) {
							root.focusedWorkspace = ws
						}
						for (const win of root.windows) {
							if (win.workspaceId === ws.workspaceId) {
								ws.windows.push(win)
							}
						}
						workspaces.push(ws)
					}
					workspaces = workspaces.sort((a, b) => a.idx - b.idx)
					root.workspaces = workspaces
					return
				}
				else if (event.WorkspaceActivated) {
					console.info("NiriService: Workspace activated")
					const ws = event.WorkspaceActivated
					if (root.focusedWorkspace) {
						root.focusedWorkspace.isFocused = false
					}
					for (const workspace of root.workspaces) {
						if (workspace.workspaceId === ws.id) {
							workspace.isFocused = true
							root.focusedWorkspace = workspace
							return
						}
					}
					console.warn("NiriService: New focused workspace not found. This likely a bug in the IPC implementation.")
					return
				}
				else if (event.WindowsChanged) {
					console.info("NiriService: Windows changed")
					for (let workspace of root.workspaces) {
						workspace.windows = []
					}
					const eventWindows = event.WindowsChanged.windows
					let windows = []
					for (const win of eventWindows) {
						const winObj = windowComp.createObject(null, {
							windowId: win.id,
							title: win.title,
							appId: win.app_id,
							pid: win.pid,
							workspaceId: win.workspace_id,
							isFocused: win.is_focused,
							isFloating: win.is_floating,
							isUrgent: win.is_urgent
						})
						if (winObj.isFocused) {
							root.focusedWindow = winObj
						}
						windows.push(winObj)
						for (let workspace of root.workspaces) {
							if (workspace.workspaceId === winObj.workspaceId) {
								workspace.windows.push(winObj)
								break
							}
						}
					}
					root.windows = windows
				}
				else if (event.WindowOpenedOrChanged) {
					console.info("NiriService: Window opned or changed")
					const win = event.WindowOpenedOrChanged.window
					const winObj = windowComp.createObject(null, {
						windowId: win.id,
						title: win.title,
						appId: win.app_id,
						pid: win.pid,
						workspaceId: win.workspace_id,
						isFocused: win.is_focused,
						isFloating: win.is_floating,
						isUrgent: win.is_urgent
					})
					for (let window of root.windows) {
						if (window.id === winObj) {
							window = winObj
						}
					}
					root.windows.push(winObj)
					for (let ws of root.workspaces) {
						if (ws.workspaceId === winObj.workspaceId) {
							for (let win of ws.windows) {
								if (win.windowId === winObj.windowId) {
									win = winObj
									return
								}
							}
							ws.windows.push(winObj)
							return
						}
					}
				}
				else if (event.WindowClosed) {
					console.info("NiriService: Window closed")
					const id = event.WindowClosed.id
					for (const win of root.windows) {
						if (win.windowId === id) {
							root.windows.splice(root.windows.indexOf(win), 1)
							break
						}
					}
					for (const ws of root.workspaces) {
						for (const win of ws.windows) {
							if (win.windowId === id) {
								ws.windows.splice(ws.windows.indexOf(win), 1)
							}
						}
					}
				}
				else if (event.WindowFocusChanged) {
					console.info("NiriService: Window focus changed")
					const id = event.WindowFocusChanged.id
					if (root.focusedWindow) {
						root.focusedWindow.isFocused = false
					}
					for (let win of root.windows) {
						if (win.id === id) {
							win.isFocused = true
							root.focusedWindow = win
							return
						}
					}
				}
			}
		}
    }
}
