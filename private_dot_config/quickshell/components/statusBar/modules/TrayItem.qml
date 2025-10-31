import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

MouseArea {
    id: root

    required property SystemTrayItem modelData
	required property real itemSize

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    implicitWidth: itemSize
    implicitHeight: itemSize

    onClicked: event => {
        if (event.button === Qt.LeftButton)
            modelData.activate()
        else
            modelData.secondaryActivate()
    }

    IconImage {
        id: icon

        asynchronous: true
        anchors.fill: parent
		mipmap: true

        source: {
            let icon = root.modelData.icon;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
        }
    }
}
