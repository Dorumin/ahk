; This file does some very fancy stuff with a single key + the scroll wheel to do alt tabbing solely with the mouse!
; Assuming you have a key on your mouse to power this, of course. I use F13, which is mapped by a mouse side button

global ALT_TABBING := false
global CONSECUTIVE_F13S := 0

; This is called when the wheel scrolls up. It's a function to allow dynamic binding with Hotkey()
OnWheelUp(*) {
    global ALT_TABBING

    if not ALT_TABBING {
        ALT_TABBING := true
        Send("{Alt down}")
    }

    Send("{Shift down}{Tab}{Shift up}")
}

; This is called when the wheel scrolls down. It's a function to allow dynamic binding with Hotkey()
OnWheelDown(*) {
    global ALT_TABBING

    if not ALT_TABBING {
        ALT_TABBING := true
        Send("{Alt down}")
    }

    Send("{Tab}")
}

F13:: {
    global CONSECUTIVE_F13S

    if A_PriorKey != "F13" {
        CONSECUTIVE_F13S := 1
    } else {
        CONSECUTIVE_F13S := CONSECUTIVE_F13S + 1
    }

    HotIf
    Hotkey("WheelUp", OnWheelUp, "On")
    Hotkey("WheelDown", OnWheelDown, "On")
}

F13 up:: {
    global ALT_TABBING, CONSECUTIVE_F13S

    HotIf
    Hotkey("WheelUp", "Off")
    Hotkey("WheelDown", "Off")

    if ALT_TABBING {
        ; Target window was selected via scroll wheel
        Send("{Alt up}")
    } else {
        if Mod(CONSECUTIVE_F13S, 2) == 0 {
            ; Submit when pressing F13 twice in a row
            Send("{Enter}")
        } else {
            ; Ctrl+Alt+Tab toggles the alt+tab menu for clicking
            Send("^!{Tab}")
        }
    }

    ALT_TABBING := false
}
