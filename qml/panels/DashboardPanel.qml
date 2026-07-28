import QtQuick 2.15

import "../devices"

Rectangle {
    id: rootId

    property int fontSize: 30
    property var model: []
    property url testVideoFile:
        "file:///C:/Users/vince/Documents/QT/EchoBoomMaster/videos/1_qt.wmv"

    color: "blue"

    Text {
        anchors.centerIn: parent
        text: "Second Panel"
        font.pixelSize: fontSize
    }


    DevicePopup {
        anchors.centerIn: parent

        device: ({
            deviceId: "DEVICE-01",
            status: "SAFE",
            latitude: 40.7831,
            longitude: -74.2396,
            videoFile: rootId.testVideoFile
        })
    }

    Timer {
        interval: 5000
        running: true
        repeat: false

        onTriggered: {
            console.log("Clearing device videoFile")
            rootId.testVideoFile = "file:///C:/Users/vince/Documents/QT/EchoBoomMaster/videos/2_qt.wmv"
        }
    }
    // function onCountChanged(model) {
    //     console.log("MapPanel model count:", model.count)
    // }
}
