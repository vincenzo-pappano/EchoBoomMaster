import QtQuick 2.15

Rectangle {
    property int fontSize: 30
    property var model: []

    color: "blue"
    Text {
        anchors.centerIn: parent
        text: "Second Panel"
        font.pixelSize: fontSize
    }

    // function onCountChanged(model) {
    //     console.log("MapPanel model count:", model.count)
    // }

}
