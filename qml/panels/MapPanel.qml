import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.settings 1.0

MapRefreshContainer {
    id: root

    property var originalCenter:
        QtPositioning.coordinate(33.01854549251185, 79.18638459788156)

    property int originalZoomLevel: 14

    Plugin {
        id: mapPlugin
        name: "esri"
    }

    Map {
        id: mainMap

        anchors.fill: parent

        plugin: mapPlugin

        center: root.originalCenter
        zoomLevel: root.originalZoomLevel

        Component.onCompleted: {
            for (var t = 0;
                 t < supportedMapTypes.length;
                 ++t) {

                if (supportedMapTypes[t].style ===
                        MapType.SatelliteMapDay) {

                    activeMapType = supportedMapTypes[t]
                    break
                }
            }
        }
    }
}

// import QtQuick 2.15

// Rectangle {
//     id: mapPanelId
//     property int fontSize: 30
//     property string text: ""

//     color: "royalblue"
//     Text {
//         anchors.centerIn: parent
//         text: mapPanelId.text
//         font.pixelSize: mapPanelId.fontSize
//     }
// }