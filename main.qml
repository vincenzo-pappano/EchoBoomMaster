import QtQuick 2.15
import QtQuick.Window 2.15
import Qt.labs.settings 1.1
import QtQuick.Layouts 1.15

Window {
    id: root
    width: 1280
    height: 720
    visible: true
    title: qsTr("Hello World")

    minimumWidth: 800
    minimumHeight: 450


    Rectangle {

        anchors.fill: parent
        color: "royalblue" //"#e8e8e8"

        RowLayout {

            anchors.fill: parent

            Rectangle {
                id: firstPanelId

                Layout.preferredWidth: (root.width*3)/4
                Layout.fillHeight: true

                color: "royalblue"
                //border.color: "#808080"
                //border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "First Panel"
                    font.pixelSize: 20
                }
            }

            Rectangle {
                id: secondPanelId

                Layout.preferredWidth: root.width/4
                Layout.fillHeight: true

                color: "blue"
                //border.color: "#808080"
                //border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "Second Panel"
                    font.pixelSize: 20
                }
            }
        }
    }
}
