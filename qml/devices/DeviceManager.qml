import QtQuick 2.15

Item {
    id: rootId

    property string appRootUrl: ""
    property string deviceJsonFile: appRootUrl + "data/devices.json"
    property var devices: []

    signal devicesLoaded()

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
                    devicesLoaded()
                    //console.log("JSON shape: top-level array")
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

    }

}


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
