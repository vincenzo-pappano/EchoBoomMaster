import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.settings 1.0

import "../devices"

MapRefreshContainer {
    id: rootId

    property var originalCenter:
        QtPositioning.coordinate(33.01854549251185, 79.18638459788156)

    property int originalZoomLevel: 14

    property var model: []

    Plugin {
        id: mapPlugin
        name: "esri"
    }

    Map {
        id: mainMap

        anchors.fill: parent

        center: rootId.originalCenter
        zoomLevel: rootId.originalZoomLevel

        plugin: mapPlugin

        property var model: rootId.model

        MapItemView {
            model: rootId.model
            delegate: deviceDelegateId
        } // MapViewItem

        Component {
            id: deviceDelegateId
            MapQuickItem {
                // 1 - where to draw it (anchorPoint is normally (0,0))
                //coordinate: QtPositioning.coordinate(mainMap.center.latitude, mainMap.center.longitude)
                coordinate: QtPositioning.coordinate(latitude, longitude)
                anchorPoint.x: ledId.width / 2
                anchorPoint.y: ledId.height / 2
                // 2 - what to draw
                sourceItem: DeviceLed {
                    id: ledId
                    width: 20

                    onLedClicked: {
                        console.log("Clicked:", deviceId, " State:", status)
                        status = status === "ACTIVE" ? "INACTIVE" : "ACTIVE"
                    }
                } // Rectangle
            } // MapQuickItem
        } // Component

        Component.onCompleted: {
            for (var t = 0; t < supportedMapTypes.length; ++t) {
                if (supportedMapTypes[t].style === MapType.SatelliteMapDay) {
                    activeMapType = supportedMapTypes[t]
                    break
                }
            }
            console.log("MapPanel.qml => model.length:", model.length)
        }
    }

    // function onCountChanged(model) {
    //     console.log("MapPanel model count:", model.count)
    // }

}
