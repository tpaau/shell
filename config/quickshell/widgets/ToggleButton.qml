import qs.widgets

StyledButton {
	id: root

	property int inactiveTheme: StyledButton.OnSurfaceContainer
	property int activeTheme: StyledButton.Primary
	property bool toggled: false

	theme: toggled ? activeTheme : inactiveTheme
	radius: toggled ? Math.min(width, height) / 4 : Math.min(width, height) / 2
	onClicked: toggled = !toggled
}
