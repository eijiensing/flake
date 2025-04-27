import { App } from "astal/gtk3"
import { Variable, GLib, bind } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Battery from "gi://AstalBattery"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Tray from "gi://AstalTray"

function SysTray() {
    const tray = Tray.get_default()

    return <box className="SysTray">
        {bind(tray, "items").as(items => items.map(item => (
            <menubutton
                tooltipMarkup={bind(item, "tooltipMarkup")}
                usePopover={false}
                actionGroup={bind(item, "actionGroup").as(ag => ["dbusmenu", ag])}
                menuModel={bind(item, "menuModel")}>
                <icon gicon={bind(item, "gicon")} />
            </menubutton>
        )))}
    </box>
}

function Wifi() {
    const network = Network.get_default()
    const wifi = bind(network, "wifi")

    return <box vertical visible={wifi.as(Boolean)}>
        {wifi.as(wifi => wifi && (
            <icon
                tooltipText={bind(wifi, "ssid").as(String)}
                className="Wifi"
                icon={bind(wifi, "iconName")}
            />
        ))}
    </box>

}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return <box className="AudioSlider" css="min-width: 140px">
        <icon icon={bind(speaker, "volumeIcon")} />
    </box>
}

function BatteryLevel() {
    const bat = Battery.get_default();

    return (
        <box className="battery" vertical>
            <circularprogress
                className="circular"
                rounded
                start-at={bind(bat, "percentage").as(p => {
                    return p && !isNaN(p) ? 1 - p : 0;
                })}
                value={bind(bat, "percentage")}
            >
                <icon
                    className="icon"
                    icon={bind(bat, "battery-icon-name")}
                />
            </circularprogress>
        </box>
    );
}

function Workspaces() {
    const hypr = Hyprland.get_default()

    return <box vertical className="Workspaces">
        {bind(hypr, "workspaces").as(wss => wss
            .filter(ws => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .sort((a, b) => a.id - b.id)
            .map(ws => (
                <button
                    className={bind(hypr, "focusedWorkspace").as(fw =>
                        ws === fw ? "focused" : "")}
                    onClicked={() => ws.focus()}>
                    {ws.id}
                </button>
            ))
        )}
    </box>
}

function Time() {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format("%H\n%M")!)

    return <label
                className="Time"
                onDestroy={() => time.drop()}
                label={time()}
            />

}

export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, BOTTOM } = Astal.WindowAnchor

    return <window
        className="Bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | BOTTOM}>
        <centerbox vertical className="container"
                start-widget={
                  <box spacing={8} vertical halign={Gtk.Align.CENTER} hexpand={false}>
                    <BatteryLevel/>
                    <Workspaces/>
                  </box>
                }
                end-widget={
                <box spacing={8} valign={Gtk.Align.END} vertical halign={Gtk.Align.CENTER} hexpand={false}>
                  <SysTray/>
                  <Wifi/>
                  <Time/>
                </box>
                }
        />
    </window>
}
