import { App } from "ags/gtk3"
import style from "./bar-style.scss"
import Bar from "./widget/Bar"
import Applauncher from "./widget/Applauncher"

App.start({
    css: style,
    instanceName: "bar",
    main: () => App.get_monitors().map(Bar),
})
