import QtQuick 2.15

import "../media"

Rectangle {
    id: rootId

    property var device
    property string videoRootUrl

    width: 260
    height: contentColumn.implicitHeight + 20

    radius: 4
    color: "#202832"

    border.color: "white"
    border.width: 1

    z: 1000

    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 10

        spacing: 6

        VideoPreview {
            width: parent.width
            height: width * 9 / 16

            sourceUrl: rootId.device && rootId.device.videoFile
                       ? rootId.videoRootUrl + rootId.device.videoFile
                       : ""
            active: rootId.visible
                    && rootId.device
                    && rootId.device.videoFile
        }

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