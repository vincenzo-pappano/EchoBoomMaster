import QtQuick 2.15

Item {
    id: rootId

    property string appRootUrl: ""
    property string deviceJsonFile: appRootUrl + "data/devices.json"
    property var devices: []
    property alias model: deviceModel

    property int activeCount: 0
    property int safeCount: 0

    signal devicesLoaded(int count)

    ListModel {
        id: deviceModel
    }


    Component.onCompleted: {
    }


    function loadDevices() {
        console.log(appRootUrl)
        console.log(deviceJsonFile)
        var xhr = new XMLHttpRequest()

        xhr.onreadystatechange = function() {

            if ( xhr.readyState === XMLHttpRequest.UNSENT) {

                console.log("UNSENT")

            } else if ( xhr.readyState === XMLHttpRequest.OPENED) {

                console.log("OPENED")

            } else if ( xhr.readyState === XMLHttpRequest.HEADERS_RECEIVED) {

                console.log("HEADERS RECEIVED")

            } else if ( xhr.readyState === XMLHttpRequest.LOADING) {

                console.log("LOADING")

            } else if(xhr.readyState === XMLHttpRequest.DONE ) {

                console.log("DONE")

                var parsed = JSON.parse(xhr.responseText)
                //console.log(xhr.responseText)

                if (parsed instanceof Array) {
                    devices = parsed

                    deviceModel.clear()

                    for(var i=0; i<devices.length; i++) {
                        var device = devices[i]
                        if(!isValidDevice(device)) {
                            console.warn("Skipping invalid devices at index", i)
                            continue
                        }
                        console.log("Loading device:",
                                    device.deviceId,
                                    "lat:", device.coordinates.latitude,
                                    "lon:", device.coordinates.longitude,
                                    "videoMode:", device.video ? device.video.mode : "none",
                                    "videoFile:", device.video ? device.video.file : "",
                                    "videoUdpPort", (device.video && device.video.udpPort !== undefined ? Number(device.video.udpPort) : 0) )

                        // NOTICE: the device model is flat
                        deviceModel.append({
                            deviceId: String(device.deviceId),
                            latitude: Number(device.coordinates.latitude),
                            longitude: Number(device.coordinates.longitude),
                            status: String(device.status || "SAFE"),
                            videoMode: device.video ? String(device.video.mode || "") : "",
                            videoFile: device.video ? String(device.video.file || "") : "",
                            videoUdpPort: device.video && device.video.udpPort !== undefined
                                        ? Number(device.video.udpPort)
                                        : 0
                        })


                    } // for
                    devicesLoaded(devices.length) // emit signal

                } else if (parsed.devices !== undefined) {
                    devices = parsed.devices
                    //console.log("JSON shape: object with devices array")
                } else {
                    //console.log("ERROR: JSON found, but no devices array")
                    devices = []
                }
            }
        }

        xhr.onerror = function() {
            console.log("XHR network error")
        }

        xhr.open("GET", deviceJsonFile)
        xhr.send()
    } // loadDevices()

    function isValidDevice(device) {

        if (!device) {
            console.log("Device is undefined")
            return false
        }

        if (device.deviceId === undefined) {
            console.log("Device ID is undefined")
            return false
        }

        if (!device.coordinates) {
            console.log("Coordinates are undefined")
            return false
        }

        if (device.coordinates.latitude === undefined) {
            console.log("Latitude is undefined")
            return false
        }
        if (device.coordinates.longitude === undefined) {
            console.log("Longitute is undefined")
            return false
        }

        var lat = Number(device.coordinates.latitude)
        var lon = Number(device.coordinates.longitude)

        if (isNaN(lat) || isNaN(lon)) {
            console.log("Latitude or Longitude is NAN")
            return false
        }

        if (lat < -90.0 || lat > 90.0) {
            console.log("Latitude invalid value")
            return false
        }

        if (lon < -180.0 || lon > 180.0) {
            console.log("Longitude invalid value")
            return false
        }

        return true
    } // isValidDevice()

    function updateTotals() {
        var active = 0
        var safe = 0

        for (var i = 0; i < deviceModel.count; ++i) {
            var device = deviceModel.get(i)

            if (device.status === "ACTIVE")
                ++active
            else if (device.status === "SAFE")
                ++safe
        }

        activeCount = active
        safeCount = safe

        console.log(active, safe)
    }

    Connections {
        target: deviceModel

        onDataChanged: rootId.updateTotals()
        onCountChanged: rootId.updateTotals()
    }}


// var xhr = new XMLHttpRequest()

// console.log("Trying to load devices JSON from:", deviceJsonFile)

// xhr.open("GET", deviceJsonFile)

// xhr.onreadystatechange = function() {
//     if (xhr.readyState === XMLHttpRequest.DONE) {
//         console.log("Device JSON request completed")
//         console.log("Device JSON status:", xhr.status)
//         console.log("Device JSON path:", deviceJsonFile)
//         console.log("Device JSON response length:", xhr.responseText.length)
//         console.log("Device JSON first 200 chars:",
//                     xhr.responseText.substring(0, 200))

//         if (xhr.status === 200 || xhr.status === 0) {
//             console.log("Device JSON file FOUND")

//             var parsed = JSON.parse(xhr.responseText)

//             if (parsed instanceof Array) {
//                 devices = parsed
//                 console.log("JSON shape: top-level array")
//             } else if (parsed.devices !== undefined) {
//                 devices = parsed.devices
//                 console.log("JSON shape: object with devices array")
//             } else {
//                 console.log("ERROR: JSON found, but no devices array")
//                 devices = []
//             }

//             recomputeCounters()

//             console.log("Loaded devices count:", devices.length)
//             console.log("Active devices count:", activeDevices)
//         } else {
//             console.log("ERROR: Device JSON file NOT found or unreadable")
//             devices = []
//             totalDevices = 0
//             activeDevices = 0
//         }
//     }
// }

// xhr.send()
// }
