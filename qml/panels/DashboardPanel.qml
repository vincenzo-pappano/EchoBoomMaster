import QtQuick 2.15

Rectangle {
    id: secondPanelId
    property int fontSize: 30

    color: "blue"
    Text {
        anchors.centerIn: parent
        text: "Second Panel"
        font.pixelSize: fontSize
    }
}
