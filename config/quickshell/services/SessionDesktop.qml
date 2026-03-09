import QtQuick

// Can't put this in `Session` because apparently you can't have enums in singletons.
QtObject {
	enum Type {
		Niri,
		Sway,
		Hyprland,
		Unknown
	}
}
