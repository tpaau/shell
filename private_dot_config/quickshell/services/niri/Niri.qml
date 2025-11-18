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

	onWorkspacesChanged: {
		for (const workspace of workspaces) {
			console.warn(`workspaceId: ${workspace.workspaceId}`)
			console.warn(`idx: ${workspace.idx}`)
			console.warn(`output: ${workspace.output}`)
		}
	}

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
			console.warn(window.windowId)
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

				// ✨ Magic ✨
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
								? workspace.active_window_id : -1
						})
						if (ws.isFocused) {
							root.focusedWorkspace = ws
						}
						workspaces.push(ws)
					}
					// workspaces = workspaces.sort((a, b) => a.workspaceId - b.workspaceId)
					root.workspaces = workspaces
				}
				else if (event.WorkspaceActivated) {
					const ws = event.WorkspaceActivated
 					if (root.focusedWorkspace) {
						root.focusedWorkspace.isFocused = false
					}
					for (const workspace of root.workspaces) {
						if (workspace.output == ws.output && workspace.idx == ws.idx) {
							workspace.isFocused = true
							root.focusedWorkspace = workspace
						}
					}
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
						workspaceId: win.workspace_id ? win.workspace_id : 0,
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
}
