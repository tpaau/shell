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

	// Every monitor has at least one workspace, so we poll for outputs every
	// time workspaces change.
	onWorkspacesChanged: outputProc.running = true

	// The currently focused workspace.
	property Workspace focusedWorkspace: null

	// All the windows registered in Niri.
	property list<NiriWindow> windows: []

	// The currently focused window.
	property NiriWindow focusedWindow: null

	// Monitor outputs recognized by Niri.
	property list<NiriOutput> outputs: []

	// The output that contains the focused workspace.
	readonly property NiriOutput focusedOutput: outputs.find(
		o => o.name == focusedWorkspace.output
	)

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

	function outputFromShellScreen(screen: ShellScreen): NiriOutput {
		return outputs.find(o => o.name == screen.name)
	}

	Component {
		id: layoutComp
		WindowLayout {}
	}

	Component {
		id: windowComp
		NiriWindow {}
	}

	Component {
		id: workspaceComp
		Workspace {}
	}

	Component {
		id: niriOutputMode
		OutputMode {}
	}

	Component {
		id: niriOutput
		NiriOutput {}
	}

	// Niri unfortunately does not provide output information in the event stream,
	// so I had to implement my own wrapper for `niri msg outputs`.
	Process {
		id: outputProc
		command: ["niri", "msg", "-j", "outputs"]
		running: true // Poll as soon as the service is loaded

		stdout: StdioCollector {
			onStreamFinished: {
				const parsedOutputs = JSON.parse(text)
				let outputs = []
				for (const parsedOutput of Object.keys(parsedOutputs)) {
					const output = parsedOutputs[`${parsedOutput}`]
					let modes = []
					for (const parsedMode of output.modes) {
						modes.push(niriOutputMode.createObject(root, {
							width: parsedMode.width,
							height: parsedMode.height,
							refreshRate: parsedMode.refresh_rate,
							isPreferred: parsedMode.is_preferred
						}))
					}
					outputs.push(niriOutput.createObject(root, {
						name: output.name,
						make: output.make,
						model: output.model,
						serial: output.serial,
						physicalWidth: output.physical_size[0],
						physicalHeight: output.physical_size[1],
						modes: modes,
						currentMode: output.current_mode,
						isCustomMode: output.is_custom_mode,
						vrrSupported: output.vrr_supported,
						vrrEnabled: output.vrr_enabled,
					}))
				}
				root.outputs = outputs
			}
		}
	}

	// Poll the outputs when `Quickshell.screens` changes.
	Connections {
		target: Quickshell
		function onScreensChanged() {
			outputProc.running = true
		}
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
			function createWindow(data: var): NiriWindow {
				if (!data) console.warn("[Window] Data is not truthy!")
				return windowComp.createObject(root, {
					windowId: data.id,
					title: data.title,
					appId: data.app_id,
					pid: data.pid,
					workspaceId: data.workspace_id ?? -1,
					isFocused: data.is_focused,
					isFloating: data.is_floating,
					isUrgent: data.is_urgent,
					layout: createLayout(data.layout),
				})
			}

			function createLayout(data: var): WindowLayout {
				if (!data) console.warn("[Layout] Data is not truthy!")
				return layoutComp.createObject(root, {
					tileIndexInScrollingLayout: data.pos_in_scrolling_layout ?
						data.pos_in_scrolling_layout[0] : -1,
					columnIndexInScrollingLayout: data.pos_in_scrolling_layout ?
						data.pos_in_scrolling_layout[1] : -1,
					tileWidth: data.tile_size[0] ?? -1,
					tileHeight: data.tile_size[1] ?? -1,
					windowWidth: data.window_size[0] ?? -1,
					windowHeight: data.window_size[1] ?? -1,
					tilePosInWorkspaceViewX: data.tile_pos_in_workspace_view ?
						data.tile_pos_in_workspace_view[0] : -1,
					tilePosInWorkspaceViewY: data.tile_pos_in_workspace_view ?
						data.tile_pos_in_workspace_view[1] : -1,
					windowOffsetInTileX: data.window_offset_in_tile[0],
					windowOffsetInTileY: data.window_offset_in_tile[1],
				})
			}

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
						const winObj = createWindow(win)
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
					const winObj = createWindow(win)
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
						if (win.windowId === id) {
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
				else if (event.WindowLayoutsChanged) {
					// For some reason I have to iterate over this manually.
					// Javascript truly is a cursed language.
					for (let i = 0; i < event.WindowLayoutsChanged.changes.length; i++) {
						const change = event.WindowLayoutsChanged.changes[i]
						const win = root.windows.find(w => w.windowId == change[0])
						if (win) {
							win.layout = createLayout(change[1])
						}
					}
				}
				else {
					// If you depend on an event that is not implemented here either
					// open a PR or message me.
					console.debug(`Unsupported event: ${JSON.stringify(event)}`)
				}
			}
		}
    }
}
