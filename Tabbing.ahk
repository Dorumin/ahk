; This file does some very fancy stuff with a single key + the scroll wheel to do alt tabbing solely with the mouse
; Assuming you have a key on your mouse to power this, of course. I use F13, which is mapped by a mouse side button

tab_key_held := false
is_alt_tabbing := false
not_responding := false
consecutive_tab_presses := 0

EnsureExplorerActive() {
    global not_responding

    if not_responding and not WinActive('ahk_class Shell_TrayWnd') {
        WinActivate('ahk_class Shell_TrayWnd')
        not_responding := false
    }
}

; Wheel handlers, functions to allow dynamic binding with Hotkey()
OnWheelUp(*) {
    global is_alt_tabbing

    EnsureExplorerActive()

    if not is_alt_tabbing {
        is_alt_tabbing := true
        Send("{Alt down}")
    }

    Send("{Shift down}{Tab}{Shift up}")
}

OnWheelDown(*) {
    global is_alt_tabbing

    EnsureExplorerActive()

    if not is_alt_tabbing {
        is_alt_tabbing := true
        Send("{Alt down}")
    }

    Send("{Tab}")
}

; Not needed with AHI registering
; F13::OnTabKeyDown()
; F13 up::OnTabKeyUp()

devices := AHI.GetDeviceList()

for index, device in devices {
    if not device.IsMouse {
        ; Do not intercept it cause it otherwise isn't picked up by AHK
        ; and therefore doesn't show up in A_PriorKey
        AHI.SubscribeKeyboard(device.id, false, OnKeyboardStateChange)
    }
}

OnKeyboardStateChange(code, pressed) {
    global not_responding

    ; TODO: Remember why I didn't use SubscribeKey. I'm sure there was a reason. Maybe lag?
    if code != GetKeySC('F13') {
        return
    }

    try {
        ; This block can fail; it's fine. Fuck it.
        try {
            active_id := WinExist('A')
            active_title := active_id and WinGetTitle(active_id)
            ; DebugView(Format("Key state: {}`nPrior key: {}`nActive ID: {}`nActive title: {}`nActive shell: {}",
            ;     pressed,
            ;     A_PriorKey,
            ;     active_id,
            ;     active_title,
            ;     WinActive('ahk_class Shell_TrayWnd')
            ; ))

            if StrEndsWith(active_title, '(Not Responding)') {
                not_responding := true
            }
        } catch as e {
            MsgBox(Format('Error in inner tab block: {} at {}:{}', e.Message, e.File, e.Line))
        }

        if pressed == 1 {
            OnTabKeyDown()
        } else {
            OnTabKeyUp()
        }
    } catch as e {
        MsgBox(Format('error: {} at {}:{}', e.Message, e.File, e.Line))
    }
}

OnTabKeyDown() {
    global tab_key_held, consecutive_tab_presses

    if A_PriorKey != "F13" {
        consecutive_tab_presses := 1
    } else {
        consecutive_tab_presses := consecutive_tab_presses + 1
    }

    if tab_key_held {
        return
    }

    tab_key_held := true

    EnsureExplorerActive()

    HotIf
    Hotkey("WheelUp", OnWheelUp, "On")
    Hotkey("WheelDown", OnWheelDown, "On")
}

OnTabKeyUp() {
    global tab_key_held, is_alt_tabbing, consecutive_tab_presses

    if not tab_key_held {
        return
    }

    tab_key_held := false

    HotIf
    Hotkey("WheelUp", "Off")
    Hotkey("WheelDown", "Off")

    EnsureExplorerActive()

    if is_alt_tabbing {
        ; Target window was selected via scroll wheel
        Send("{Alt up}")
    } else {
        if Mod(consecutive_tab_presses, 2) == 0 {
            ; Submit when pressing F13 twice in a row
            Send("{Enter}")
        } else {
            ; Ctrl+Alt+Tab toggles the alt+tab menu for clicking
            ; Key detail: When explorer.exe is focused, it DOESN'T focus
            ; the second item in the tab list automatically. It sticks to the first
            if WinActive('ahk_class Shell_TrayWnd') {
                Send("!^{Tab}")
                Sleep(0)
                Send('{Tab}')
            } else {
                Send("!^{Tab}")
            }
        }
    }

    is_alt_tabbing := false
}
