pragma Singleton

import Quickshell

Singleton {
	readonly property int topLeft: 0
	readonly property int top: 1
	readonly property int topRight: 2
	readonly property int right: 3
	readonly property int bottomRight: 4
	readonly property int bottom: 5
	readonly property int bottomLeft: 6
	readonly property int left: 7

	function fromEdge(edge: Edges): int {
		if (edge === Edges.Top)
			return top
		else if (edge === Edges.Right)
			return right
		else if (edge === Edges.Bottom)
			return bottom
		else if (edge === Edges.Left)
			return left
		else
			return -1
	}
}
