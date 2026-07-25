import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../panels"
import "../devices"

ScaledFixedAspectRatioWindow {
    id: rootId

    property int fontSize: 30
    property string rootAppRootUrl: ""
    property var model: deviceManagerId.model

    visible: true
    title: qsTr("Hello World")

    Component.onCompleted: {
        deviceManagerId.loadDevices()
    }

    DeviceManager {
        id: deviceManagerId
        appRootUrl: rootId.rootAppRootUrl

        onDevicesLoaded: {
            console.log("Loaded ",count," devices")
            console.log("Model Device Data")
            for(var i=0; i<model.count; i++) {
                var obj = model.get(i)
                console.log("ID:", obj.deviceId,
                            "| lat:", obj.latitude,
                            "| lon:", obj.longitude,
                            "| videoMode:", obj.videoMode,
                            "| videoFile:", obj.videoFile,
                            "| videoUdpPort", obj.videoUdpPort)
            }
        }
    } // DeviceManager

    Rectangle {
        anchors.fill: parent
        color: "royalblue"

        RowLayout {
            anchors.fill: parent

            MapPanel {
                id: mapPanelId

                Layout.fillWidth: true
                Layout.fillHeight: true

                fontSize: rootId.fontSize
            }

            DashboardPanel {
                id: dashboardPanelId

                Layout.preferredWidth: 420
                Layout.fillHeight: true

                fontSize: rootId.fontSize
            }
        }
    }
}
