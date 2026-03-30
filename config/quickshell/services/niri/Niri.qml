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

	property bool configValid: true

	signal screenshotCaptured(path: string)

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
					focusTimestamp: data.focus_timestamp != null ?
						data.focus_timestamp.secs + data.focus_timestamp.nanos / 1000000000.0
						: -1.0
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

			function focusWindow(id: int) {
				if (id == -1) {
					root.focusedWindow = null
					for (let win of root.windows) {
						win.isFocused = false
					}
					return
				}
				if (root.focusedWindow) root.focusedWindow.isFocused = false
				for (let win of root.windows) {
					if (win.windowId === id) {
						win.isFocused = true
						root.focusedWindow = win
						return
					}
				}
			}

			onRead: line => {
				const event = JSON.parse(line)

				/// Handle the Niri event. The full list of events can be found here:
				// https://docs.rs/niri-ipc/latest/niri_ipc/enum.Event.html
				if (event.WorkspacesChanged) {
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
							activeWindowId: workspace.active_window_id != null ?
								workspace.active_window_id : -1
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
				} else if (event.WorkspaceUrgencyChanged) {
					const ev = event.WorkspaceUrgencyChanged
					let workspace = root.workspaces.find(w => w.workspaceId === ev.id)
					if (workspace) {
						workspace.urgent = ev.urgent
					} else {
						console.warn(`Could not find the workspace with ID ${ev.id}. This is a bug in the IPC implementation.`)
					}
				} else if (event.WorkspaceActivated) {
					if (root.focusedWorkspace) {
						root.focusedWorkspace.isFocused = false
					}
					const ev = event.WorkspaceActivated
					let workspace = root.workspaces.find(w => w.workspaceId === ev.id)
					if (workspace) {
						workspace.isFocused = true
						root.focusedWorkspace = workspace
					} else {
						console.warn(`Could not find the workspace with ID ${ev.id}. This is a bug in the IPC implementation.`)
					}
				} else if (event.WorkspaceActiveWindowChanged) {
					const ev = event.WorkspaceActiveWindowChanged
					const workspace = root.workspaces.find(
						w => w.workspaceId == ev.workspace_id
					)
					if (workspace) {
						workspace.activeWindowId = ev.active_window_id != null ?
							ev.active_window_id : -1
					} else {
						console.warn(`Workspace with id ${ev.workspace_id} not found. This is likely a bug in the IPC implementation.`)
					}
				} else if (event.WindowsChanged) {
					let windows = []
					for (const win of event.WindowsChanged.windows) {
						windows.push(createWindow(win))
					}
					root.windows = windows
					focusWindow(root.windows.find(w => w.isFocused)?.windowId ?? -1)
				} else if (event.WindowOpenedOrChanged) {
					const win = createWindow(event.WindowOpenedOrChanged.window)
					const foundWindow = root.windows.find(w => w.windowId === win.windowId)
					if (foundWindow) {
						root.windows[root.windows.indexOf(foundWindow)] = win
						if (win.isFocused) focusWindow(win.windowId)
					} else {
						if (win.isFocused) focusWindow(win.windowId)
						root.windows.push(win)
					}
				} else if (event.WindowClosed) {
					root.windows = root.windows.filter(
						w => w.windowId !== event.WindowClosed.id
					)
				} else if (event.WindowFocusChanged) {
					focusWindow(event.WindowFocusChanged.id == null ?
						-1 : event.WindowFocusChanged.id)
				} else if (event.WindowFocusTimestampChanged) {
					const ev = event.WindowFocusTimestampChanged
					const win = root.windows.find(w => w.windowId === ev.id)
					if (win) {
						win.focusTimestamp = ev.focus_timestamp != null ?
							ev.focus_timestamp.secs + ev.focus_timestamp.nanos / 1000000000.0
							: -1
					} else {
						console.warn(`Could not find window with id ${ev.id}. This is likely a bug in the IPC implementation.`)
					}
				} else if (event.WindowUrgencyChanged) {
					const win = root.windows.find(
						w => w.windowId === event.WindowUrgencyChanged.id
					)
					if (win) {
						win.isUrgent = event.WindowUrgencyChanged.urgent
					} else {
						console.warn(`Could not find window with id ${event.WindowUrgencyChanged.id}. This is likely a bug in the IPC implementation.`)
					}
				} else if (event.WindowLayoutsChanged) {
					// For some reason I have to iterate over this manually.
					// Javascript truly is a cursed language.
					for (let i = 0; i < event.WindowLayoutsChanged.changes.length; i++) {
						const change = event.WindowLayoutsChanged.changes[i]
						const win = root.windows.find(w => w.windowId == change[0])
						if (win) {
							win.layout = createLayout(change[1])
						}
					}
				} else if (event.KeyboardLayoutsChanged) {
					const ev = event.KeyboardLayoutsChanged
					root.keyboardLayoutIndex = ev.keyboard_layouts.current_idx
					root.keyboardLayouts = ev.keyboard_layouts.names
				} else if (event.KeyboardLayoutsSwitched) {
					root.keyboardLayoutIndex = event.KeyboardLayoutsChanged.idx
				} else if (event.OverviewOpenedOrClosed) {
					root.overviewOpened = event.OverviewOpenedOrClosed.is_open
				} else if (event.ConfigLoaded) {
					root.configValid = !event.ConfigLoaded.failed
				} else if (event.ScreenshotCaptured) {
					const path = event.ScreenshotCaptured.path != null ?
						event.ScreenshotCaptured.path : ""
					root.screenshotCaptured(path)
				} else if (event.Ok) {
					/// This one seems to be a response to the event stream command as
					//it's not in the docs.
				} else {
					console.warn(`Unsupported event: ${JSON.stringify(event)}`)
				}
			}
		}
    }
}
