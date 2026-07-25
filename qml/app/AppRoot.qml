import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.1
import QtQuick.Layouts 1.15
import CustomWindow 1.0

import "../panels"
import "../devices"

FixedAspectRatioWindow {
    id: rootWindow

    property int fontSize: 30
    property string rootAppRootUrl: ""

    visible: true
    title: qsTr("Hello World")

    width: 1280
    height: 720

    minimumWidth: 800
    minimumHeight: 450

    readonly property real baseWidth: 1920
    readonly property real baseHeight: 1080

    aspectRatio: baseWidth / baseHeight

    readonly property real currentScale: Math.min(
                                             width / baseWidth,
                                             height / baseHeight
                                             )


    DeviceManager {
        id: deviceManagerId
        appRootUrl: rootAppRootUrl

        onDevicesLoaded: {
            console.log(JSON.stringify(deviceManagerId.devices))
        }
    }

    Item {
        id: scaledContent

        width: rootWindow.baseWidth
        height: rootWindow.baseHeight

        x: (rootWindow.width -
            width * rootWindow.currentScale) / 2

        y: (rootWindow.height -
            height * rootWindow.currentScale) / 2

        transform: Scale {
            origin.x: 0
            origin.y: 0

            xScale: rootWindow.currentScale
            yScale: rootWindow.currentScale
        }

        Rectangle {

            anchors.fill: parent
            color: "royalblue"

            RowLayout {

                anchors.fill: parent

                MapPanel {
                    id: mapPanelId
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    fontSize: rootWindow.fontSize
                }

                DashboardPanel {
                    id: dashboardPanelId
                    Layout.preferredWidth: 420
                    Layout.fillHeight: true
                    fontSize: rootWindow.fontSize
                }

            }
        } // Rectangle
    } // Item

    Component.onCompleted: {
        deviceManagerId.loadDevices()
    }
}