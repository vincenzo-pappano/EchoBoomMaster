import QtQuick 2.15

import "../devices"

Rectangle {
    id: rootId

    property int fontSize: 30
    property var model: []

    color: "blue"

    Text {
        anchors.centerIn: parent
        text: "Second Panel"
        font.pixelSize: fontSize
    }

}
