import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets

Item {
    id: radialVolume
    width: 36
    height: 36
    property color barColor: "#81A8DE"
    property color backgroundColor: "#978d74"
    property int lineWidth: 6

    PwObjectTracker {
        objects: Pipewire.nodes.values
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            const sink = Pipewire.defaultAudioSink
            var v = 0
            var muted = false
            if (Pipewire.ready && sink?.ready && sink?.audio) {
                v = Number(sink.audio.volume) || 0
                muted = sink.audio.muted
            }

            // Circle center
            const cx = width/2
            const cy = height/2
            const radius = width/2 - lineWidth

            // Draw background circle
            ctx.beginPath()
            ctx.arc(cx, cy, radius, 0, 2*Math.PI)
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = backgroundColor
            ctx.stroke()

            // Draw progress arc
           const endAngle = Math.min(v, 2) * 2 * Math.PI // allow >100%
            ctx.beginPath()
            ctx.arc(cx, cy, radius, -Math.PI/2, -Math.PI/2 - endAngle, true)
            ctx.strokeStyle = muted ? "#555555" : barColor
            ctx.stroke()
        }

        // Refresh every frame for volume updates
        Timer {
            interval: 100
            running: true
            repeat: true
            onTriggered: canvas.requestPaint()
        }
    }

    Image {
        id: icon
        anchors.centerIn: parent
        width: 12
        height: 12
        fillMode: Image.PreserveAspectFit

        source: {
            const sink = Pipewire.defaultAudioSink
            if (!Pipewire.ready || !sink?.ready || !sink?.audio) return "volume-off.svg"

            if (sink.audio.muted) return "volume-off.svg"

            const vol = Number(sink.audio.volume) || 0
            if (vol <= 0.33) return "volume.svg"
            else if (vol <= 0.66) return "volume-1.svg"
            else return "volume-2.svg"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            const sink = Pipewire.defaultAudioSink
            if (sink?.ready && sink?.audio) {
                sink.audio.muted = !sink.audio.muted
            }
        }
    }
}
