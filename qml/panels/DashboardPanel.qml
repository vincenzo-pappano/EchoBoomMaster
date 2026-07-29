import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

// import "../dashboard"

Rectangle {
    id: dashboardPanel


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
            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            Layout.topMargin: 50
            Layout.fillWidth: true
        }

        Rectangle {
            id: statRow1

            property string label: "Total Devices"
            property int value: deviceManagerId.totalDevices

            Layout.topMargin: 4
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            radius: 8
            color: "#1f2328"
            border.color: "#505a66"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 20

                spacing: 10

                Text {
                    text: statRow1.label
                    color: "#d8d8d8"
                    font.pixelSize: 18

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: statRow1.value
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true

                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }
        }
        Rectangle {
            id: statRow2

            property string label: "Active Devices"
            property int value: deviceManagerId.safeDevices

            Layout.topMargin: 4
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            radius: 8
            color: "#1f2328"
            border.color: "#505a66"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 20

                spacing: 10

                Text {
                    text: statRow2.label
                    color: "#d8d8d8"
                    font.pixelSize: 18

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: statRow2.value
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true

                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }
        }
        Rectangle {
            id: statRow3

            property string label: "Total Detections"
            property int value: deviceManagerId.totalDevices-deviceManagerId.safeDevices

            Layout.topMargin: 4
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            radius: 8
            color: "#1f2328"
            border.color: "#505a66"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 20

                spacing: 10

                Text {
                    text: statRow3.label
                    color: "#d8d8d8"
                    font.pixelSize: 18

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: statRow3.value
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true

                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }
        }
        Rectangle {
            id: statRow4

            property string label: "Total Triggered"
            property int value: deviceManagerId.totalDevices-deviceManagerId.safeDevices

            Layout.topMargin: 4
            Layout.fillWidth: true
            Layout.preferredHeight: 60

            radius: 8
            color: "#1f2328"
            border.color: "#505a66"
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                anchors.rightMargin: 20

                spacing: 10

                Text {
                    text: statRow4.label
                    color: "#d8d8d8"
                    font.pixelSize: 18

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }

                Text {
                    text: statRow4.value
                    color: "white"
                    font.pixelSize: 24
                    font.bold: true

                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                }
            }
        }

        RowLayout {
            id: btnRowLayout

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 80

            spacing: 12

            property int btnWidth: 180
            property int fontSize: 24

            Button {
                id: btnActive

                Layout.preferredWidth: btnRowLayout.btnWidth

                text: qsTr("DISARM")

                contentItem: Text {
                    text: btnActive.text + ": " + deviceManagerId.activeDevices
                    color: "white"
                    font.pixelSize: btnRowLayout.fontSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "#1f7a3a"
                    radius: 4

                    border.color: "white"
                    border.width: 1
                }

                onClicked: {
                    console.log("Clicked DISARM")
                    armAll(false)
                }
            }

            Button {
                id: btnSafe

                Layout.preferredWidth: btnRowLayout.btnWidth

                text: qsTr("ARM")

                contentItem: Text {
                    text: btnSafe.text + ": " + deviceManagerId.safeDevices
                    color: "white"
                    font.pixelSize: btnRowLayout.fontSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: "#8a2c2c"
                    radius: 4

                    border.color: "white"
                    border.width: 1
                }

                onClicked: {
                    console.log("Clicked ARM")
                    armAll(true)
                }
            }
        }


        // Consumes all unused vertical space, pushing the items below
        // to the bottom of the panel.
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
