import QtQuick 2.15

Rectangle {
    id: mapPanelId
    property int fontSize: 30
    property string text: ""

    color: "royalblue"
    Text {
        anchors.centerIn: parent
        text: mapPanelId.text
        font.pixelSize: mapPanelId.fontSize
    }
}