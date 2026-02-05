import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

ShellRoot {
    id: root
		property color backgroundColor: "#FCF6EA"
		property color primaryColor: "#81A8DE"
		property color secondaryColor: "#978D74"

		VerticalBar {
			backgroundColor: root.backgroundColor
			primaryColor: root.primaryColor
			secondaryColor: root.secondaryColor
		} 
}

