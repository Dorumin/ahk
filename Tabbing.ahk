global ALT_TABBING := false
global CONSECUTIVE_F15S := 0

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
    global CONSECUTIVE_F15S

    if A_PriorKey != "F15" {
        CONSECUTIVE_F15S := 1
    } else {
        CONSECUTIVE_F15S := CONSECUTIVE_F15S + 1
    }

    HotIf
    Hotkey("WheelUp", OnWheelUp, "On")
    Hotkey("WheelDown", OnWheelDown, "On")
}

F15 up:: {
    global ALT_TABBING, CONSECUTIVE_F15S

    HotIf
    Hotkey("WheelUp", "Off")
    Hotkey("WheelDown", "Off")

    if ALT_TABBING {
        ; Target window was selected via scroll wheel
        Send("{Alt up}")
    } else {
        if Mod(CONSECUTIVE_F15S, 2) == 0 {
            ; Submit when pressing F15 twice in a row
            Send("{Enter}")
        } else {
            ; Ctrl+Alt+Tab toggles the alt+tab menu for clicking
            Send("^!{Tab}")
        }
    }

    ALT_TABBING := false
}
