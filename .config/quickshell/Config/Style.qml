pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property Radius radius: Radius {}
    property Colors colors: Colors {}
    property FontFamily fontFamily: FontFamily {}
    property FontSize fontSize: FontSize {}
    property AnimationDuration animationDuration: AnimationDuration {}

    component Colors: JsonObject {
        property string fg: "#f8f8f2"
        property string bg: "#ed282A36"
    }

    component Radius: JsonObject {
        property int normal: 8
    }

    component FontFamily: JsonObject {
        property string mono: "JetBrains Mono Nerd Font"
        property string sans: "Inter Variable"
        property string icon: "JetBrains Mono Nerd Font"
        property string nerd: "JetBrains Mono Nerd Font"
    }

    component FontSize: JsonObject {
        property int smaller: 11
        property int small: 13
        property int normal: 16
        property int large: 18
        property int larger: 24
    }

    component AnimationDuration: JsonObject {
        property int fast: 120
        property int normal: 240
        property int slow: 360
        property int slower: 480
    }
}
