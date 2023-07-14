global HOLDING_BUTTON := false
global ALT_TABBING := false

~WheelUp:: {
    global HOLDING_BUTTON, ALT_TABBING

    if HOLDING_BUTTON {
        if not ALT_TABBING {
            ALT_TABBING := 1
            Send("{Alt down}")
        }

        Send("{Shift down}{Tab}{Shift up}")
    }
}

~WheelDown:: {
    global HOLDING_BUTTON, ALT_TABBING

    if HOLDING_BUTTON {
        if not ALT_TABBING {
            ALT_TABBING := 1
            Send("{Alt down}")
        }

        Send("{Tab}")
    }
}

F15:: {
    global

    HOLDING_BUTTON := true
    ; ALT_TABBING := false ; can't do this sanity assignment due to key spamming
}

F15 up:: {
    global

    if ALT_TABBING {
        ; Target window was selected via scroll wheel
        Send("{Alt up}")
    } else {
        ; Ctrl+Alt+Tab toggles the alt+tab menu for clicking
        Send("^!{Tab}")
    }

    HOLDING_BUTTON := false
    ALT_TABBING := false
}
