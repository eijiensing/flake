import { App } from "ags/gtk3"
import style from "./launcher-style.scss"
import Applauncher from "./widget/Applauncher"

App.start({
    instanceName: "launcher",
    css: style,
    main: Applauncher,
})
