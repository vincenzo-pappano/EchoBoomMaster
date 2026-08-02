import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "../common"

RowLayout {
    id: root

    Layout.alignment: Qt.AlignHCenter
    Layout.topMargin: 80
    spacing: 12

    property int btnWidth: 180
    property int fontSize: 24

    property string btnActiveText: qsTr('DISARM')
    property string btnActiveColor: "#1f7a3a"
    property bool btnActiveIsArmed: false

    property string btnSafeText: qsTr('ARM')
    property string btnSafeColor: "#8a2c2c"
    property bool btnSafeIsArmed: true

    signal armAll(bool arm)

    ControlButton {
        id: btnActive

        Layout.preferredWidth: root.btnWidth
        textFontSize: root.fontSize
        text: root.btnActiveText
        buttonColor: root.btnActiveColor
        onClicked: { armAll(root.btnActiveIsArmed) }
    }
    ControlButton {
        id: btnSafe

        Layout.preferredWidth: root.btnWidth
        textFontSize: root.fontSize
        text: root.btnSafeText
        buttonColor: root.btnSafeColor
        onClicked: { armAll(root.btnSafeIsArmed) }
    }
}
