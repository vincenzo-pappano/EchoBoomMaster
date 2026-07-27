import QtQuick 2.15

Rectangle {
    id: rootId

    property var device

    width: 260
    height: 120

    radius: 4
    color: "#202832"

    border.color: "white"
    border.width: 1

    z: 1000

    Column {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 6

        Text {
            width: parent.width

            text: rootId.device
                  ? rootId.device.deviceId
                  : "Unknown Device"

            color: "white"
            font.pixelSize: 18
            font.bold: true
        }

        Text {
            width: parent.width

            text: "Status: "
                  + (rootId.device
                     ? rootId.device.status
                     : "")

            color: "white"
            font.pixelSize: 14
        }

        Text {
            width: parent.width

            text: "Latitude: "
                  + (rootId.device
                     ? rootId.device.latitude
                     : "")

            color: "white"
            font.pixelSize: 14
        }

        Text {
            width: parent.width

            text: "Longitude: "
                  + (rootId.device
                     ? rootId.device.longitude
                     : "")

            color: "white"
            font.pixelSize: 14
        }
    }
}