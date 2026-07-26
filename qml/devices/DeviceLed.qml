import QtQuick 2.15

Rectangle {
    property bool ledIsGreen: status === "ACTIVE"

    signal ledClicked()

    width: 16
    height: width
    radius: width/2

    color: ledIsGreen ? "#00ff00" : "#ff0000"
    border.color: "black"
    border.width: 2

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton

        onClicked: {
            ledClicked()
        }
    }
}
