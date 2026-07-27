import QtQuick 2.15
import QtQuick.Controls 2.15

Dialog {
    id: rootId
    property var device

    parent: Overlay.overlay

    modal: true
    focus: true
    dim: false

    width: 140
    height: 120

    property int fontSize: 12

    property real dragOffsetX: 0
    property real dragOffsetY: 0

    // function keepInsideOverlay(newX, newY) {
    //     x = Math.max(
    //                 0,
    //                 Math.min(
    //                     newX,
    //                     Overlay.overlay.width - width
    //                 )
    //             )

    //     y = Math.max(
    //                 0,
    //                 Math.min(
    //                     newY,
    //                     Overlay.overlay.height - height
    //                 )
    //             )
    // }

    background: Rectangle {
        id: backgroundId

        color: "#202630"
        radius: 4
        border.color: "#808080"
        border.width: 1
    }

    header: Rectangle {
        id: dialogHeader
        radius: backgroundId.radius
        border.color: backgroundId.border.color
        border.width: backgroundId.border.width

        width: parent.width
        height: 26

        color: "#303844"

        Text {
            anchors.centerIn: parent

            text: "EchoBoom"

            color: "white"
            font.pixelSize: rootId.fontSize+4
            font.bold: true
        }

        // MouseArea {
        //     id: dialogHeaderMouseArea

        //     anchors.fill: parent

        //     acceptedButtons: Qt.LeftButton
        //     cursorShape: Qt.SizeAllCursor

        //     onPressed: function(mouse) {
        //         var globalPosition =
        //                 dialogHeaderMouseArea.mapToGlobal(
        //                     mouse.x,
        //                     mouse.y
        //                 )

        //         var overlayPosition =
        //                 Overlay.overlay.mapFromGlobal(
        //                     globalPosition.x,
        //                     globalPosition.y
        //                 )

        //         rootId.dragOffsetX =
        //                 overlayPosition.x - rootId.x

        //         rootId.dragOffsetY =
        //                 overlayPosition.y - rootId.y
        //     }

        //     onPositionChanged: function(mouse) {
        //         if (!pressed)
        //             return

        //         var globalPosition =
        //                 dialogHeaderMouseArea.mapToGlobal(
        //                     mouse.x,
        //                     mouse.y
        //                 )

        //         var overlayPosition =
        //                 Overlay.overlay.mapFromGlobal(
        //                     globalPosition.x,
        //                     globalPosition.y
        //                 )

        //         armDialog.keepInsideOverlay(
        //                     overlayPosition.x
        //                         - armDialog.dragOffsetX,
        //                     overlayPosition.y
        //                         - armDialog.dragOffsetY
        //                 )
        //     }
        // }

        Rectangle {
            id: closeButton

            width: 18
            height: 18

            anchors.right: parent.right
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter

            radius: 4
            color: closeMouseArea.containsMouse ? "#8a2c2c" : "lightgrey"
            z: 2

            Text {
                anchors.centerIn: parent
                text: "\u00D7"
                color: "white"
                font.pixelSize: rootId.fontSize+6
                font.bold: true
            }

            MouseArea {
                id: closeMouseArea

                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    rootId.close()
                }
            }
        }
    }


    contentItem: Column {
        id: columnId
        spacing: 6

        Text {
            id: popupText
            anchors.horizontalCenter: parent.horizontalCenter

            text: rootId.device.deviceId

            color: "white"
            font.pixelSize: rootId.fontSize
            font.bold: true
        }

        Column {
            id: popupButtonRow

            property bool ledIsGreen: status === "SAFE"

            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter

            spacing: columnId.spacing-2

            Button {
                id: btnSafe

                text: qsTr("ARM")
                width: 120
                height: 24

                enabled: rootId.device.status === "ACTIVE"
                onClicked: {
                    rootId.device.status = "SAFE"
                }

                contentItem: Text {
                    text: btnSafe.text
                    color: "white"
                    font.pixelSize: rootId.fontSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: enabled ? "#8a2c2c" : "#D3D3D3"
                    radius: 4

                    border.color: "white"
                    border.width: 1
                }
            }


            Button {
                id: btnActive

                text: qsTr("DISARM")
                width: 120
                height: 24

                enabled: rootId.device.status === "SAFE"
                onClicked: {
                    rootId.device.status = "ACTIVE"
                    console.log("clicked")
                }

                contentItem: Text {
                    text: btnActive.text
                    color: "white"
                    font.pixelSize: rootId.fontSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: enabled ? "#1f7a3a" : "#D3D3D3"
                    radius: 4

                    border.color: "white"
                    border.width: 1
                }
            }

            // Repeater {
            //     model: [
            //         { name: "ARM", color: "#8a2c2c", ledIsGreen: false },
            //         { name: "DISARM", color: "#1f7a3a", ledIsGreen: true },
            //     ]

            //     Rectangle {
            //         width: 120
            //         height: 24
            //         radius: 4

            //         color: modelData.color
            //         border.color: "white"
            //         border.width: 1

            //         Text {
            //             anchors.centerIn: parent
            //             text: modelData.name
            //             color: "white"
            //             font.pixelSize: rootId.fontSize
            //             font.bold: true
            //         }
            //         MouseArea {
            //             id: buttonMouseArea

            //             anchors.fill: parent
            //             acceptedButtons: Qt.LeftButton
            //             cursorShape: Qt.PointingHandCursor

            //             onClicked: {
            //                 console.log(deviceId)
            //                 // if (compositeDevice.ledIsGreen === modelData.ledIsGreen) {
            //                 //     console.log("LED already",
            //                 //                 modelData.ledIsGreen ? "GREEN" : "RED",
            //                 //                 "- no change")
            //                 //     return
            //                 // }
            //                 // compositeDevice.setLedIsGreen(modelData.ledIsGreen)

            //             } // onClicked
            //         } // MouseArea
            //     } // Rectangle
            // } // Repeater

        }
    }

}
