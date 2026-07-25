import QtQuick 2.15

Rectangle {
    id: firstPanelId
    property int fontSize: 30

    color: "royalblue"
    Text {
        anchors.centerIn: parent
        text: "Map Panel"
        font.pixelSize: fontSize
    }
}