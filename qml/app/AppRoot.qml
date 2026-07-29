import QtQuick 2.15
import QtQuick.Layouts 1.15

import "../panels"
import "../devices"

ScaledFixedAspectRatioWindow {
    id: rootId

    property int fontSize: 30
    property string rootAppRootUrl: ""
    property string rootVideoRootUrl: ""
    property string rootGitCommitId: ""

    //signal armAll(bool arm)

    visible: true
    title: qsTr("Hello World")

    Component.onCompleted: {
        deviceManagerId.loadDevices()
        console.log("Git Commit ID: ", rootGitCommitId)
    }

    DeviceManager {
        id: deviceManagerId
        appRootUrl: rootId.rootAppRootUrl

        onDevicesLoaded: {
            console.log("Loaded ",count," devices")
        }
    } // DeviceManager

    Rectangle {

        anchors.fill: parent
        color: "royalblue"

        RowLayout {

            anchors.fill: parent

            MapPanel {

                id: mapPanelId
                videoRootUrl: rootId.rootVideoRootUrl

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: deviceManagerId.model

            } // MapPanel

            DashboardPanel {

                id: dashboardPanelId

                Layout.preferredWidth: 420
                Layout.fillHeight: true

                fontSize: rootId.fontSize

                model: deviceManagerId.model
                deviceManager: deviceManagerId

                onArmAll: {

                    for(var i=0; i<model.count; i++) {
                        var status = arm ? "SAFE" : "ACTIVE"
                        var device = model.get(i)
                        device.status = status
                        console.log(device.status)
                    }
                    console.log(deviceManagerId.activeCount, deviceManagerId.safeCount)
                }
            } // DashboardPanel

        } // RowLayout
    } // Rectangle
}
