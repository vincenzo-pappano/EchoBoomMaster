import QtQuick 2.15
import QtMultimedia 5.15

Item {
    id: rootId

    property url sourceUrl: ""
    property bool active: false

    function updatePlayback() {
        playTimerId.stop()
        videoId.stop()

        if (active && sourceUrl.toString() !== "") {
            playTimerId.restart()
        }
    }

    onActiveChanged: updatePlayback()
    onSourceUrlChanged: updatePlayback()

    Component.onCompleted: updatePlayback()

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Timer {
        id: playTimerId

        interval: 150
        repeat: false

        onTriggered: {
            var fullUrl = Qt.resolvedUrl(rootId.sourceUrl)

            console.log("VideoPreview sourceUrl:",
                        rootId.sourceUrl.toString())

            console.log("VideoPreview resolved URL:",
                        fullUrl.toString())

            if (rootId.active &&
                    rootId.sourceUrl.toString() !== "") {
                videoId.play()
            }
        }
    }

    Video {
        id: videoId

        anchors.fill: parent

        source: rootId.sourceUrl
        muted: true
        loops: MediaPlayer.Infinite
        autoPlay: false
        fillMode: VideoOutput.PreserveAspectFit

        onErrorChanged: {
            if (error !== MediaPlayer.NoError) {
                console.log("Video error:", errorString)
            }
        }
    }
}