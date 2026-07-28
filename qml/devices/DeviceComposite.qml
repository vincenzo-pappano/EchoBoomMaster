import QtQuick 2.15

Item {
    id: rootId

    signal ledClicked()
    signal bodyHoverChanged(bool hovered)

    property var device

    readonly property real ledWidth: deviceLed.width
    readonly property real ledHeight: deviceLed.height
    readonly property int dialogOffset: deviceLed.dialogOffset

    readonly property real ledCenterX: deviceLed.x + deviceLed.width / 2
    readonly property real ledCenterY: deviceLed.y + deviceLed.height / 2
    readonly property real compositeRight: Math.max(deviceLed.x + deviceLed.width,deviceBody.x + deviceBody.width)
    readonly property real compositeTop: Math.min(deviceLed.y, deviceBody.y)
    readonly property real popupOffsetX: compositeRight - ledCenterX + 10
    readonly property real popupOffsetY: compositeTop - ledCenterY

    function openLedDialogAtGlobal(globalX, globalY) {
        deviceLed.openDialogAtGlobal(globalX, globalY)
    }

    readonly property int popupOffset: 8


    DeviceLed {
        id: deviceLed

        device: rootId.device

        x: 0
        y: 0
        z: 40

        onLedClicked: {
            console.log("DeviceComposite.qml: ledClicked()")

            rootId.ledClicked()

            console.log(
                "DeviceComposite.qml",
                device.deviceId,
                device.status
            )
        }
    }

    DeviceBody {
        id: deviceBody

        device: rootId.device

        x: 8
        y: -10
        z: 30

        onBodyHoverChanged: {
            rootId.bodyHoverChanged(hovered)
        }
    }
}