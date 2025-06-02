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

    return <box vertical className="systray">
        {bind(tray, "items").as(items => items.map(item => (
            <menubutton
                className=""
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
                className="wifi"
                icon={bind(wifi, "iconName")}
            />
        ))}
    </box>

}

function Audio() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return (
        <box className="audio" vertical>
            <circularprogress
                className="circular"
                rounded
                start-at={-0.25}
                end-at={0.75}
                value={bind(speaker, "volume")}
            >
                <icon
                    className="icon"
                    tooltipText={bind(speaker, "volume").as(String)}
                    icon={bind(speaker, "volumeIcon")}
                />
            </circularprogress>
        </box>
    );
}

function BatteryLevel() {
    const bat = Battery.get_default();

    return (
        <box className="battery" vertical>
            <circularprogress
                className="circular"
                rounded
                start-at={-0.25}
                end-at={0.75}
                value={bind(bat, "is-battery").as(Boolean) ? bind(bat, "percentage") : 1}
            >
                <icon
                    className="icon"
                    tooltipText={bind(bat, "percentage").as(String)}
                    icon={bind(bat, "battery-icon-name")}
                />
            </circularprogress>
        </box>
    );
}

function Workspaces() {
    const hypr = Hyprland.get_default()

    return <box vertical className="workspaces">
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


function Date() {
    const date = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format("%d/%m")!)

    return <label
                className="date"
                onDestroy={() => date.drop()}
                label={date()}
            />

}

function Time() {
    const time = Variable<string>("").poll(1000, () =>
        GLib.DateTime.new_now_local().format("%H\n%M")!)

    return <label
                className="time"
                onDestroy={() => time.drop()}
                label={time()}
            />

}

export default function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, BOTTOM } = Astal.WindowAnchor

    return <window
        className="bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | BOTTOM}>
        <centerbox vertical className="container"
                start-widget={
                  <box spacing={8} vertical halign={Gtk.Align.CENTER} hexpand={false}>
                    <BatteryLevel/>
                    <Audio/>
                    <Workspaces/>
                  </box>
                }
                end-widget={
                <box spacing={8} valign={Gtk.Align.END} vertical halign={Gtk.Align.CENTER} hexpand={false}>
                  <SysTray/>
                  <Wifi/>
                  <Time/>
                  <Date/>
                </box>
                }
        />
    </window>
}
