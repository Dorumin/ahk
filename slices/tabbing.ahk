; This file does some very fancy stuff with a single key + the scroll wheel to do alt tabbing solely with the mouse
; Assuming you have a key on your mouse to power this, of course. I use F13, which is mapped by a mouse side button

#Include ../src/all.ahk

tab_key_held := false
is_alt_tabbing := false
not_responding := false
consecutive_tab_presses := 0

EnsureExplorerActive() {
    global not_responding

    if not_responding and not WinActive('ahk_class Shell_TrayWnd') {
        WinActivate('ahk_class Shell_TrayWnd')
        not_responding := false

        return true
    }

    return false
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

TabFocused() {
    return WinActive('ahk_class XamlExplorerHostIslandWindow')
}

OnKeyboardStateChange(code, pressed) {
    global not_responding

    ; TODO: Remember why I didn't use SubscribeKey. I'm sure there was a reason. Maybe lag?
    if code != GetKeySC('F13') {
        return
    }

    try {
        active_id := WinExist('A')

        if active_id {
            ; WinGetPos(&x, &y, &w, &h, active_id)

            active_title := WinGetTitle(active_id)
            active_class := WinGetClass(active_id)
            active_controls := WinGetControls(active_id)

            ; LogMessage(Format("title: {} x: {} y: {} w: {} h: {}", active_title, x, y, w, h))
            ; DebugView(Format("Key state: {}`nPrior key: {}`nActive ID: {}`nActive title: {}`nActive shell: {}",
            ;     pressed,
            ;     A_PriorKey,
            ;     active_id,
            ;     active_title,
            ;     WinActive('ahk_class Shell_TrayWnd')
            ; ))
            unresponsive := ((
                StrEndsWith(active_title, '(Not Responding)')
            ) or (
                ; "Not responding... close" window
                active_class == "#32770"
                and active_controls.Length == 17
            ))

            ; LogMessage(Format("tabbing active title: {} active class: {} control count: {} unresp: {}",
            ;     active_title,
            ;     active_class,
            ;     active_controls.Length,
            ;     unresponsive
            ; ))

            if unresponsive {
                not_responding := true
            }
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

    was_not_responding := EnsureExplorerActive()

    if is_alt_tabbing {
        ; Target window was selected via scroll wheel
        Send("{Alt up}")
    } else {
        if Mod(consecutive_tab_presses, 2) == 0 {
            ; Submit when pressing F13 twice in a row
            if not TabFocused() {
                LogMessage('enter when not focused')
            } else {
                Send("{Enter}")
            }
        } else {
            ; Ctrl+Alt+Tab toggles the alt+tab menu for clicking
            ; Key detail: When explorer.exe is focused, it DOESN'T focus
            ; the second item in the tab list automatically. It sticks to the first
            if WinActive('ahk_class Shell_TrayWnd') {
                Send('{Alt down}{Ctrl down}{Tab}{Tab}{Ctrl up}{Alt up}')
                ; Send("!^{Tab}")
                ; It needs to wait a bit to show the damn tab ui
                ; Sleep(100)
                ; Send('{Tab}')
            } else {
                Send("!^{Tab}")
            }
        }
    }

    is_alt_tabbing := false
}
