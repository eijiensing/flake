import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Widgets

Item {
    id: radialBattery
    width: 36
    height: 36

    property color barColor: "#81A8DE"
    property color backgroundColor: "#978d74"
    property int lineWidth: 6

    // The system battery device
    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // UPower displayDevice is the aggregated battery info
            const bat = UPower.displayDevice
            var pct = 0

            if (bat?.ready) {
                pct = Number(bat.percentage)
            }

            const cx = width/2
            const cy = height/2
            const radius = width/2 - lineWidth

            // background
            ctx.beginPath()
            ctx.arc(cx, cy, radius, 0, 2 * Math.PI)
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = backgroundColor
            ctx.stroke()

            // progress arc
            const endAngle = Math.min(pct, 1) * 2 * Math.PI
            ctx.beginPath()
            ctx.arc(cx, cy, radius, -Math.PI/2, -Math.PI/2 - endAngle, true)
            ctx.strokeStyle = barColor
            ctx.stroke()
        }

        Timer {
            interval: 1000
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
            const bat = UPower.displayDevice
            if (!UPower.onBattery) return "battery-charging.svg"

            const pct = Number(bat.percentage)
            if (pct <= 0.33) return "battery-low.svg"
            else if (pct <= 0.66) return "battery-medium.svg"
            else return "battery-full.svg"
        }
    }
}
