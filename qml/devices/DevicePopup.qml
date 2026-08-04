import QtQuick 2.15
import EchoBoom.Video 1.0

import "../media"

Rectangle {
    id: rootId

    property var device
    property string videoRootUrl

    readonly property string videoMode:
        device && device.videoMode
        ? String(device.videoMode)
        : "file"

    readonly property string videoFile:
        device && device.videoFile
        ? String(device.videoFile)
        : ""

    readonly property int videoUdpPort:
        device && device.videoUdpPort !== undefined
        ? Number(device.videoUdpPort)
        : 0

    width: 260*1.5
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

        Item {
            id: videoAreaId

            width: parent.width
            height: width * 9 / 16

            VideoPreview {
                id: fileVideoId

                anchors.fill: parent

                visible: rootId.videoMode === "file"

                sourceUrl: rootId.videoFile !== ""
                           ? rootId.videoRootUrl + rootId.videoFile
                           : ""

                active: rootId.visible
                        && rootId.videoMode === "file"
                        && rootId.videoFile !== ""
            }

            GstVideoItem {
                id: liveVideoId

                anchors.fill: parent

                visible: rootId.visible
                         && rootId.videoMode === "stream"
                         && rootId.videoUdpPort > 0

                udpPort: rootId.videoUdpPort

                Component.onCompleted: {
                    if (visible && udpPort > 0) {
                        start()
                    }
                }

                onVisibleChanged: {
                    console.log(
                        "Live video visible:",
                        visible,
                        "port:",
                        udpPort
                    )

                    if (visible && udpPort > 0) {
                        start()
                    } else {
                        stop()
                    }
                }

                onUdpPortChanged: {
                    console.log(
                        "Live video UDP port changed:",
                        udpPort
                    )

                    if (visible && udpPort > 0) {
                        stop()
                        start()
                    }
                }
            }
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

// import QtQuick 2.15

// import "../media"

// Rectangle {
//     id: rootId

//     property var device
//     property string videoRootUrl

//     width: 260
//     height: contentColumn.implicitHeight + 20

//     radius: 4
//     color: "#202832"

//     border.color: "white"
//     border.width: 1

//     z: 1000

//     Column {
//         id: contentColumn
//         anchors.fill: parent
//         anchors.margins: 10

//         spacing: 6

//         VideoPreview {
//             width: parent.width
//             height: width * 9 / 16

//             sourceUrl: rootId.device && rootId.device.videoFile
//                        ? rootId.videoRootUrl + rootId.device.videoFile
//                        : ""
//             active: rootId.visible
//                     && rootId.device
//                     && rootId.device.videoFile
//         }

//         Text {
//             width: parent.width

//             text: rootId.device
//                   ? rootId.device.deviceId
//                   : "Unknown Device"

//             color: "white"
//             font.pixelSize: 18
//             font.bold: true
//         }

//         Text {
//             width: parent.width

//             text: "Status: "
//                   + (rootId.device
//                      ? rootId.device.status
//                      : "")

//             color: "white"
//             font.pixelSize: 14
//         }

//         Text {
//             width: parent.width

//             text: "Latitude: "
//                   + (rootId.device
//                      ? rootId.device.latitude
//                      : "")

//             color: "white"
//             font.pixelSize: 14
//         }

//         Text {
//             width: parent.width

//             text: "Longitude: "
//                   + (rootId.device
//                      ? rootId.device.longitude
//                      : "")

//             color: "white"
//             font.pixelSize: 14
//         }
//     }
// }