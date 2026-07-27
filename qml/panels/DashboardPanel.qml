import QtQuick 2.15

import "../devices"

Rectangle {
    property int fontSize: 30
    property var model: []

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
            longitude: -74.2396
        })
    }
    // function onCountChanged(model) {
    //     console.log("MapPanel model count:", model.count)
    // }
}
