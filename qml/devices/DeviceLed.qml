import QtQuick 2.15

Rectangle {
    id: rootId
    property var device
    property bool ledIsGreen: status === "ACTIVE"
    property string deviceId: deviceId

    signal ledClicked()

    width: 16
    height: width
    radius: width/2

    property int dialogOffset: 30

    color: ledIsGreen ? "#00ff00" : "#ff0000"
    border.color: "black"
    border.width: 2

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onClicked: {
            console.log("Led.qml: ledClicked()")
            console.log("DeviceId", device.deviceId, "Status:", device.status)
            rootId.ledClicked()
        }
    }

    /*
     * globalX/globalY already identify the desired
     * dialog position on the screen.
     */
    function openDialogAtGlobal(globalX, globalY) {
        if (!dialogId.parent) {
            console.warn("DeviceLedDialog has no visual parent")
            return
        }

        /*
         * dialogId.parent is Overlay.overlay because
         * DeviceLedDialog defines:
         *
         *     parent: Overlay.overlay
         */
        var overlayPoint = dialogId.parent.mapFromGlobal(
                    globalX,
                    globalY)

        /*
         * These are one-time assignments, not bindings.
         */
        dialogId.x = overlayPoint.x
        dialogId.y = overlayPoint.y

        dialogId.open()
    }

    DeviceLedDialog {
        id: dialogId
        device: rootId.device
    }
}


// ================================================================
//
//   latitude/longitude
//           ↓
//   map pixel position
//           ↓
//   global screen position
//           ↓
//   dialog overlay position
//
// ================================================================
//
//   DeviceLed clicked
//           ↓
//   DeviceComposite emits ledClicked
//           ↓
//   MapPanel converts latitude/longitude to screen pixels
//           ↓
//   DeviceComposite passes the coordinates to DeviceLed
//           ↓
//   DeviceLed converts screen coordinates to overlay coordinates
//           ↓
//   DeviceLed positions and opens the dialog
//
// ================================================================
