import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: rootId
    property var device

    property string deviceId: ""
    //readonly property bool modalVisible: armDialog.visible

    width: 40
    height: 52

    Image {
        id: deviceImage

        x: 10
        y: 0
        width: 22
        height: 42

        source: "qrc:/qml/images/device.png"
        fillMode: Image.PreserveAspectFit
    }

    Text {
        anchors.horizontalCenter: deviceImage.horizontalCenter
        anchors.top: deviceImage.bottom
        anchors.topMargin: 1

        text: rootId.deviceId
        color: "black"
        font.pixelSize: 14
        //font.bold: true

        style: Text.Outline
        styleColor: "black"
    }
}