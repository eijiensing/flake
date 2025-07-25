import { App } from "astal/gtk3"
import style from "./notifications-style.scss"
import NotificationPopups from "./widget/NotificationPopups"

App.start({
    instanceName: "notifications",
    css: style,
    main: () => App.get_monitors().map(NotificationPopups),
})
