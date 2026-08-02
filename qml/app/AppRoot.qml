import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
//import QtQuick.Dialogs 1.3 as Dialogs
import Qt.labs.platform 1.1 as Platform

import "../panels"
import "../devices"

ScaledFixedAspectRatioWindow {
    id: rootId

    property int fontSize: 30
    property string rootAppRootUrl: ""
    property string rootVideoRootUrl: ""
    property string rootGitCommitId: ""
    property var deviceFileDialog: null

    //signal armAll(bool arm)

    visible: true
    title: qsTr("EchoBoomMaster")

    Component.onCompleted: {
        console.log("Git Commit ID: ", rootGitCommitId)
    }

    DeviceManager {
        id: deviceManager
        appRootUrl: rootId.rootAppRootUrl

        onDevicesLoaded: {
            console.log("Loaded ",count," devices")
        }
    } // DeviceManager

    Component {
        id: deviceFileDialogComponent

        Platform.FileDialog {
            title: qsTr("Load Devices")

            parentWindow: rootId
            fileMode: Platform.FileDialog.OpenFile

            nameFilters: [
                qsTr("JSON files (*.json)"),
                qsTr("All files (*)")
            ]

            onAccepted: {
                console.log("Selected device file:", file)
                deviceManager.loadDevices(file)
            }
        }
    } // Component

    MenuBar {
        id: menuBarId
        font.pixelSize: 18

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        z: 10

        Menu {
            font.pixelSize: 12
            title: qsTr("Devices")
            width: 60
            height: 30
            enabled: deviceManager.model.count === 0
            topPadding: 0
            bottomPadding: 0

            MenuItem {
                implicitHeight: 30
                text: qsTr("Load ...")
                onTriggered: {
                    if (!rootId.deviceFileDialog) {
                        rootId.deviceFileDialog =
                                deviceFileDialogComponent.createObject(rootId)
                    }
                    rootId.deviceFileDialog.open()
                } // onTrigger
            } // MenuItem
        } // (Devices) Menu
        Menu {
            font.pixelSize: 12
            title: qsTr("Clear")
            width: 120
            height: 30
            enabled: deviceManager.model.count > 0
            topPadding: 0
            bottomPadding: 0

            MenuItem {
                implicitHeight: 30
                text: qsTr("Remove Devices ...")
                onTriggered: {
                    deviceManager.clearDevices()
                }
            } // MenuItem
        } // (Clear) Menu
    } // MenuBar


    Rectangle {
        anchors.top: menuBarId.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "royalblue"

        RowLayout {

            anchors.fill: parent

            MapPanel {

                id: mapPanelId
                videoRootUrl: rootId.rootVideoRootUrl

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: deviceManager.model

            } // MapPanel

            DashboardPanel {

                id: dashboardPanelId

                Layout.preferredWidth: 420
                Layout.fillHeight: true

                fontSize: rootId.fontSize

                deviceManager: deviceManager

                onArmAll: {

                    for(var i=0; i<deviceManager.model.count; i++) {
                        var status = arm ? "SAFE" : "ACTIVE"
                        var device = deviceManager.model.get(i)
                        device.status = status
                        console.log(device.status)
                    }
                    console.log("AppRoot onArmAll()", deviceManager.activeDevices, deviceManager.safeDevices)
                }
            } // DashboardPanel
        } // RowLayout
    } // Rectangle
}
