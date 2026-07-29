import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: root
    property int textFontSize: 10
    property string buttonColor: "lightgray"

    contentItem: Text {        
        text: root.text
        color: "white"
        font.pixelSize: root.textFontSize
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        color: root.buttonColor
        radius: 4

        border.color: "white"
        border.width: 1
    }
}
