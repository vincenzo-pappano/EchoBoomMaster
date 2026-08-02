import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root

    property color buttonColor
    property int textFontSize: 10
    property color textColor: "white"

    hoverEnabled: root.enabled

    contentItem: Text {
        text: root.text
        color: root.textColor
        font.pixelSize: root.textFontSize
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        color: root.enabled
               ? root.buttonColor
               : "#D3D3D3"

        radius: 4

        opacity: root.pressed ? 0.30
                              : (root.hovered ? 0.65 : 1.0)

        border.color: "white"
        border.width: 1

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
    }
}
