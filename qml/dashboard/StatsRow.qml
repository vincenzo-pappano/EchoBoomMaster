import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Rectangle {
    id: statsRow

    property string label
    property int value
    property int textFontPixelSize: 18
    property int valueFontPixelSize: 24

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
            text: statsRow.label
            color: "#d8d8d8"
            font.pixelSize: statsRow.textFontPixelSize

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: statsRow.value
            color: "white"
            font.pixelSize: statsRow.valueFontPixelSize
            font.bold: true

            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }
    }
}



// Rectangle {
//     id: statRow

//     property string label: ""
//     property int value: 0

//     width: parent.width
//     height: 60
//     radius: 8

//     color: "#1f2328"
//     border.color: "#505a66"
//     border.width: 1

//     Text {
//         anchors.left: parent.left
//         anchors.leftMargin: 18
//         anchors.verticalCenter: parent.verticalCenter

//         text: statRow.label
//         color: "#d8d8d8"
//         font.pixelSize: 18
//     }

//     Text {
//         anchors.right: parent.right
//         anchors.rightMargin: 20
//         anchors.verticalCenter: parent.verticalCenter

//         text: statRow.value
//         color: "white"
//         font.pixelSize: 24
//         font.bold: true
//     }
// }


// =====================================================================================

// import QtQuick 2.15
// import QtQuick.Controls 2.15

// Button {
//     id: root
//     property int textFontSize: 10
//     property string buttonColor: "lightgray"

//     contentItem: Text {
//         text: root.text
//         color: "white"
//         font.pixelSize: root.textFontSize
//         font.bold: true
//         horizontalAlignment: Text.AlignHCenter
//         verticalAlignment: Text.AlignVCenter
//     }

//     background: Rectangle {
//         color: root.buttonColor
//         radius: 4

//         border.color: "white"
//         border.width: 1
//     }
// }
