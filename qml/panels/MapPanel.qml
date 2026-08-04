import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import Qt.labs.settings 1.0

import "../devices"
import "../media"

MapRefreshContainer {
    id: rootId

    property string videoRootUrl
    property var originalCenter: QtPositioning.coordinate(33.01854549251185, 79.18638459788156)
    property int originalZoomLevel: 14
    property var model: []
    property var hoveredDevice: null
    property bool devicePopupVisible: false

    function zoomToAllDevices() {
        mainMap.fitViewportToMapItems()
    }

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


        DevicePopup {
            id: devicePopupId
            videoRootUrl: rootId.videoRootUrl

            z: 1000

            visible: rootId.devicePopupVisible
            device: rootId.hoveredDevice
        }

        MapItemView {
            model: rootId.model
            delegate: deviceDelegateId
        } // MapViewItem

        Component {
            id: deviceDelegateId
            MapQuickItem {
                id: mapItem
                // 1 - where to draw it (anchorPoint is normally (0,0))
                coordinate: QtPositioning.coordinate(latitude, longitude)
                anchorPoint.x: deviceCompositeId.width / 2
                anchorPoint.y: deviceCompositeId.height / 2
                // 2 - what to draw
                sourceItem: DeviceComposite {
                    id: deviceCompositeId
                    device: model
                    onLedClicked: {
                        rootId.openDialogNextToDevice(mapItem, deviceCompositeId)
                    } //
                    onBodyHoverChanged: {
                        if (hovered) {
                            rootId.hoveredDevice = deviceCompositeId.device
                            rootId.showPopupNextToDevice(mapItem, deviceCompositeId)
                            rootId.devicePopupVisible = true
                        } else {
                            rootId.devicePopupVisible = false
                        }
                    }
                } // sourceItem/DeviceComposite
            } // MapQuickItem
        } // Component

        Component.onCompleted: {
            for (var t = 0; t < supportedMapTypes.length; ++t) {
                if (supportedMapTypes[t].style === MapType.SatelliteMapDay) {
                    activeMapType = supportedMapTypes[t]
                    break
                }
            }
        } // Component
    } // Map

    MapZoomControls {
        id: zoomControls
        // anchors.right: parent.right
        // anchors.rightMargin: 18
        // anchors.verticalCenter: parent.verticalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
        zoomLevel: mainMap.zoomLevel
        minimumZoomLevel: mainMap.minimumZoomLevel
        maximumZoomLevel: mainMap.maximumZoomLevel

        onZoomInRequested: {
            mainMap.zoomLevel = Math.min(mainMap.maximumZoomLevel, mainMap.zoomLevel + 1)
        }

        onZoomOutRequested: {
            mainMap.zoomLevel = Math.max(mainMap.minimumZoomLevel, mainMap.zoomLevel - 1)
        }

        // onResetRequested: {
        //     mainMap.center = root.originalCenter
        //     mainMap.zoomLevel = root.originalZoomLevel
        // }

        onZoomToAllRequested: {
            console.log(rootId.model)
            if (rootId.model)
                if (rootId.model.count > 0)
                    mainMap.fitViewportToMapItems()
                else
                    console.log("'count' is 0")
            else
                console.log("model is undefined")
        }
    } // MapZoomControls

    Component.onCompleted: {
        console.log(videoRootUrl)
    }

    function globalPointNextToDevice(mapItem, offsetX, offsetY) {

        // Convert the device latitude/longitude into a map pixel.
        // The MapQuickItem anchor represents the center of the LED.
        var mapPoint =
                mainMap.fromCoordinate(
                    mapItem.coordinate,
                    false
                )

        // Apply offsets relative to the LED center, then convert
        // the resulting map point into global window coordinates.
        return mainMap.mapToGlobal(
            mapPoint.x + offsetX,
            mapPoint.y + offsetY
        )
    }

    function openDialogNextToDevice(mapItem, deviceComposite) {

        /*
          Preserve the exact offsets used by the existing,
          correctly positioned DeviceLedDialog.
        */
        var globalPoint =
                globalPointNextToDevice(
                    mapItem,
                    deviceComposite.ledWidth / 2
                        + deviceComposite.dialogOffset
                        - 250,
                    -deviceComposite.ledHeight / 2
                        - 70
                )

        deviceComposite.openLedDialogAtGlobal(
            globalPoint.x,
            globalPoint.y
        )
    }

    function showPopupNextToDevice(mapItem, deviceComposite) {

        /*
          Obtain the global position immediately to the right
          of the complete DeviceComposite.
        */
        var globalPoint =
                globalPointNextToDevice(
                    mapItem,
                    deviceComposite.popupOffsetX,
                    deviceComposite.popupOffsetY
                )

        /*
          DevicePopup is a normal QML item owned by MapPanel,
          so convert the global position into its parent's
          coordinate system.
        */
        var popupPoint =
                devicePopupId.parent.mapFromGlobal(
                    globalPoint.x,
                    globalPoint.y
                )

        devicePopupId.x = popupPoint.x
        devicePopupId.y = popupPoint.y
    }
}
