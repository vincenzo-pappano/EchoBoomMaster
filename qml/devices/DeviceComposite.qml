import QtQuick 2.15

Item {
    id: rootId

    signal ledClicked()
    property var device

    readonly property real ledWidth: deviceLed.width
    readonly property real ledHeight: deviceLed.height
    readonly property int dialogOffset: deviceLed.dialogOffset

    function openLedDialogAtGlobal(globalX, globalY) {
        deviceLed.openDialogAtGlobal(globalX, globalY)
    }

    DeviceLed {

        id: deviceLed
        device: rootId.device

        x: 0
        y: 0
        z: 40

        onLedClicked: {
            console.log("DeviceComposite.qml: ledClicked()")
            rootId.ledClicked()
            console.log("DeviceComposite.qml", device.deviceId, device.status)
        }
    }

    DeviceBody {

        id: deviceBody
        device: rootId.device

        x: 8
        y: -10
        z: 30

    }
}
