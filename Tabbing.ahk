global ALT_TABBING := false

OnWheelUp(_) {
    global ALT_TABBING

    if not ALT_TABBING {
        ALT_TABBING := true
        Send("{Alt down}")
    }

    Send("{Shift down}{Tab}{Shift up}")
}

OnWheelDown(_) {
    global ALT_TABBING

    if not ALT_TABBING {
        ALT_TABBING := true
        Send("{Alt down}")
    }

    Send("{Tab}")
}

F15:: {
    HotIf
    Hotkey("WheelUp", OnWheelUp, "On")
    Hotkey("WheelDown", OnWheelDown, "On")
}

F15 up:: {
    global ALT_TABBING

    HotIf
    Hotkey("WheelUp", "Off")
    Hotkey("WheelDown", "Off")

    if ALT_TABBING {
        ; Target window was selected via scroll wheel
        Send("{Alt up}")
    } else {
        ; Ctrl+Alt+Tab toggles the alt+tab menu for clicking
        Send("^!{Tab}")
    }

    ALT_TABBING := false
}
