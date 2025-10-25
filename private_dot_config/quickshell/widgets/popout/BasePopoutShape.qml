import QtQuick.Shapes
import qs.config

ShapePath {
	property real radius
	property real width
	property real height

	pathHints: ShapePath.PathFillOnRight
		| ShapePath.PathSolid
		| ShapePath.PathNonIntersecting
	fillColor: Theme.pallete.bg.c1
	strokeWidth: -1
}
