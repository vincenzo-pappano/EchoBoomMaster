import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.settings 1.0

import "../devices"
import "../media"

MapRefreshContainer {
    id: rootId

    property var originalCenter: QtPositioning.coordinate(33.01854549251185, 79.18638459788156)
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
                id: deviceMapItem
                // 1 - where to draw it (anchorPoint is normally (0,0))
                coordinate: QtPositioning.coordinate(latitude, longitude)
                anchorPoint.x: deviceCompositeId.width / 2
                anchorPoint.y: deviceCompositeId.height / 2
                // 2 - what to draw
                sourceItem: DeviceComposite {
                    id: deviceCompositeId
                    device: model
                    onLedClicked: {
                        mainMap.openDialogNextToDevice(deviceMapItem, deviceCompositeId)
                    }
                } // Rectangle
            } // MapQuickItem
        } // Component

        // VideoPreview {
        //     width: 480
        //     height: 270

        //     sourceUrl: "file:///C:/Users/vince/Documents/QT/EchoBoomMaster/videos/1_qt.wmv"
        //     active: true
        // }

        Component.onCompleted: {
            for (var t = 0; t < supportedMapTypes.length; ++t) {
                if (supportedMapTypes[t].style === MapType.SatelliteMapDay) {
                    activeMapType = supportedMapTypes[t]
                    break
                }
            }
            console.log("MapPanel.qml => model.length:", model.length)
        } // Component

        function openDialogNextToDevice(mapItem, deviceComposite) {

            // mapPoint is the map pixel corresponding to the device latitude/longitude.
            // Because anchorPoint is at the LED center, mapPoint represents the center of the LED.
            var mapPoint = mainMap.fromCoordinate(mapItem.coordinate, false)

            // Move from the LED center to: LED right edge + dialogOffset , LED top edge
            var globalPoint = mainMap.mapToGlobal(
                        mapPoint.x + deviceComposite.ledWidth / 2 + deviceComposite.dialogOffset + 20,
                        mapPoint.y - deviceComposite.ledHeight / 2 - 70 )

            // DeviceLed owns the dialog, so ask the composite to pass the position to DeviceLed.
            deviceComposite.openLedDialogAtGlobal(globalPoint.x, globalPoint.y)
        } // function

    } // Map

    // function onCountChanged(model) {
    //     console.log("MapPanel model count:", model.count)
    // }

}
