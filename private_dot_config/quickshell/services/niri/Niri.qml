// Since Quickshell doesn't have an API for Niri, only for I3 and Hyprland, I
// had to create my own.
//
// This implementation is *not* complete; some events are not handled, and only
// a handful of functions for Niri actions are implemented.
//
// Both `OverviewButtons` and `NiriWorkspaces` use this service. See those
// components for examples.
//
// Documentation based on https://yalter.github.io/niri/niri_ipc/

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

	// The name of the current keyboard layout, or "" if unknown.
	readonly property string keyboardLayout:
		keyboardLayouts.length > keyboardLayoutIndex ?
		keyboardLayouts[keyboardLayoutIndex] : ""

	// XKB names of the configured keyboard layouts.
	property list<string> keyboardLayouts: []

	// Index of the currently active layout in `keyboardLayouts`.
	property int keyboardLayoutIndex: 0

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

        onConnectionStateChanged: {
            write('"EventStream"\n') // Ask Niri to stream the events.
        }

		parser: SplitParser {
			onRead: line => {
				const event = JSON.parse(line)

				if (event.OverviewOpenedOrClosed) {
					root.overviewOpened = event.OverviewOpenedOrClosed.is_open
					return
				}
				else if (event.WorkspacesChanged) {
					let newWorkspaces = []
					for (const workspace of event.WorkspacesChanged.workspaces) {
						const ws = workspaceComp.createObject(root, {
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
						newWorkspaces.push(ws)
					}
					newWorkspaces = newWorkspaces.sort((a, b) => a.idx - b.idx)
					root.workspaces = newWorkspaces
					return
				}
				else if (event.WorkspaceActivated) {
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
					for (let workspace of root.workspaces) {
						workspace.windows = []
					}
					const eventWindows = event.WindowsChanged.windows
					let windows = []
					for (const win of eventWindows) {
						const winObj = windowComp.createObject(root, {
							windowId: win.id,
							title: win.title,
							appId: win.app_id,
							pid: win.pid,
							workspaceId: win.workspace_id ?? -1,
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
					const win = event.WindowOpenedOrChanged.window
					const winObj = windowComp.createObject(root, {
						windowId: win.id,
						title: win.title,
						appId: win.app_id,
						pid: win.pid,
						workspaceId: win.workspace_id ?? -1,
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
				else if (event.KeyboardLayoutsChanged) {
					root.keyboardLayoutIndex = event.KeyboardLayoutsChanged
						.keyboard_layouts.current_idx
					root.keyboardLayouts = event.KeyboardLayoutsChanged
						.keyboard_layouts.names
				}
			}
		}
    }
}
