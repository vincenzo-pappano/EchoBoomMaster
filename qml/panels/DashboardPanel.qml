import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "../dashboard"

Rectangle {
    id: root


    signal armAll(bool arm)

    property int fontSize: 30
    property var model: []
    property var deviceManager

    color: "#2b3038"
    border.color: "#404850"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        spacing: 0

        Image {
            id: logoImage

            source: "qrc:/qml/images/logo.png"
            fillMode: Image.PreserveAspectFit

            Layout.preferredWidth: 400
            Layout.preferredHeight: 200
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            id: titleText

            text: "EchoBoomMaster"
            color: "white"
            font.pixelSize: 30
            font.bold: true

            Layout.topMargin: 32
            Layout.bottomMargin: 50
            Layout.alignment: Qt.AlignHCenter
        }

        StatsRow {
            label: "Total Devices"
            value: root.deviceManager.totalDevices
        }
        StatsRow {
            label: "Active Devices"
            value: root.deviceManager.safeDevices
        }
        StatsRow {
            label: "Total Detections"
            value: root.deviceManager.totalDevices - root.deviceManager.safeDevices
        }
        StatsRow {
            label: "Total Triggered"
            value: root.deviceManager.totalDevices - root.deviceManager.safeDevices
        }



        ControlButtonsRow {
            deviceManager: root.deviceManager
            onArmAll: {
                root.armAll(arm)
            }
        }

        Item {
            Layout.fillHeight: true
        }

        ColumnLayout {
            spacing: -10

            Layout.preferredWidth: 400
            Layout.alignment: Qt.AlignHCenter

            Text {
                id: announceText

                text: "Mission Intelligence by:"
                color: "white"
                font.pixelSize: 20
                font.bold: true

                Layout.alignment: Qt.AlignLeft
            }

            Image {
                id: centurionImage

                source: "qrc:/qml/images/centurion.png"
                fillMode: Image.PreserveAspectFit

                Layout.preferredWidth: 400
                Layout.preferredHeight: 80
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
