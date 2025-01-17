#Include ../src/all.ahk

; Disable F1, almost always useless and pressed by accident
; Can be reactivated on a window-per-window basis
F1:: return

; Reload the script when developing or it janks out
F14 & LButton::
!F5:: {
    ; Set slow title match mode for matching controls text. It's OK because we're gonna reload the script anyways
    SetTitleMatchMode('Slow')
    error_windows := WinGetList('ahk_exe AutoHotkey64.exe', 'The script was not reloaded; the old version will remain in effect.')

    for window_id in error_windows {
        WinClose(window_id)
    }

    Reload
}

F14 & RButton:: {
    ; Or ListHotkeys, but this seems more useful
    KeyHistory
    ; Scroll to the end in the hotkey list. End by itself doesn't do it
    Send('^{End}')
}

; Stupid mind shortcut for Alt+A to middle click
!a::MButton

; Make combinator keys that I never use but are otherwise useful as characters
; send the key immediately. These bindings only really make sense in the Latin American keyboard layout

;  Ctrl+Alt+{ to send ^
^!{:: Send("{Text}^")

; Ctrl+Alt+} to send `
^!}:: Send("{Text}``")

AddWindowWatcherCallback(WindowEventCallback)
WindowEventCallback(event) {
    if event.type != 'added' or event.exe != 'C:\Windows\explorer.exe' {
        return
    }

    class := WinGetClass(event.id)

    if class != 'CabinetWClass' {
        return
    }

    ; Maximize all explorers; weirdly inconsistent in windows
    WinMaximize(event.id)

    explorer_windows := WinGetList('ahk_exe explorer.exe ahk_class CabinetWClass')
    if explorer_windows.Length == 1 {
        if explorer_windows[1] != event.id {
            MsgBox('failed validation: only one explorer window open, but is not added window.')
        }

        return
    }

    existing_explorer_id := ArrayFilter(explorer_windows, (id) => id != event.id)[1]
    text := WinGetText(event.id)
    RegExMatch(text, 'm)^Address: (?<address>.+)$', &address_match)

    if not address_match {
        MsgBox('failed during address extraction')
        return
    }

    address := address_match.address

    ; LogMessage('new-explorer-window: ' address)

    if address == 'Control Panel' {
        return
    }

    old_clipboard := A_Clipboard
    A_Clipboard := address

    WinClose(event.id)
    WinActivate(existing_explorer_id)
    Sleep(100)

    RestoreMousePosition(true, () => Click(0, 0))

    Send('^t')
    Sleep(100)
    Loop 10 {
        Send('^l^c')
        Sleep(100)

        if A_Clipboard == "This PC" {
            break
        }
    }

    A_Clipboard := address
    Sleep(0.4)

    ; SendInput('^l{Raw}' address)
    Send('^a^v')
    Send('{Enter}')

    ; Dumb delay so explorer doesn't paste the wrong thing???
    Sleep(1)
    A_Clipboard := old_clipboard

    ; DebugView(FormatObjectProps({
    ;     exe: event.exe,
    ;     id: event.id,
    ;     now: A_TickCount,
    ;     class: class,
    ;     address: address,
    ;     windows: StrJoin(explorer_windows, ',')
    ; }))
}

F23:: {
    Loop 10 {
        Send('^l{esc}^l^c')
        Sleep(100)

        if A_Clipboard == "This PC" {
            break
        }
    }
}

; Remap Win+E to open explorer.exe
; Why is this needed? Win+E already opens the Windows explorer!
; My install of Windows 11 doesn't let me set the Downloads folder as my landing page
; If I do, it crashes every time I try to open it. However, opening it from explorer.exe
; in the command line defaults to the Downloads folder, for some fucking reason
;
; Need to hide the System32 explorer.exe, not the Windows explorer.exe
; However, System32 explorer.exe opens up properly (in Downloads), so I use that
#e:: {
    if WinExist("ahk_exe explorer.exe ahk_class CabinetWClass") {
        WinActivate() ; LastFoundWindow
        Send("{Tab}^t")
        RestoreMousePosition(true, () => MouseMove(0, 0, 0))
        Sleep(150)
        RestoreMousePosition(true, () => MouseMove(0, 0, 0))
    } else {
        Run("C:\Windows\explorer.exe", , "Hide")
        WinWait("ahk_exe explorer.exe ahk_class CabinetWClass")
        WinActivate()
    }
}

; Bring back a bluetooth shortcut removed in Windows 11
; Win+K used to bring up a device list, now it brings up cast. Wtf
; Now, Win+B will toggle bluetooth connectivity and open the device list.
#b:: {
    Send("#a")
    Sleep(250)

    ; Can't pick it up...?
    ; exists := WinWait("ahk_class Windows.UI.Core.CoreWindow", , 2)

    ; Fuck it, hardcode coords
    RestoreMousePosition(true, () => (
        Click(1650, 565)
        Click(1710, 565)
    ))
}

; It's only funny a couple times
; Requires editing registry:
; HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\DisableLockWorkstation
; Ctrl+Alt+Delete still works to change user (win+L) or log out
#l:: return

is_dragging := false
start_drag_x := -1
start_drag_y := -1
drag_move_total_x := -1
drag_move_total_y := -1

ListenInterceptionDevices(
    (device) => device.IsMouse,
    (device) => (
        AHI.SubscribeMouseButton(device.id, 0, false, OnMouseButtonPressDragListener)
        AHI.SubscribeMouseMoveRelative(device.id, false, OnMouseMoveDragListener)
    )
)

OnMouseButtonPressDragListener(pressed) {
    global start_drag_x, start_drag_y, drag_move_total_x, drag_move_total_y, is_dragging

    if pressed {
        is_dragging := true
        drag_move_total_x := 0
        drag_move_total_y := 0
        MouseGetPos(&start_drag_x, &start_drag_y)
    } else {
        MouseGetPos(&end_drag_x, &end_drag_y)
        drag_move_total_x := end_drag_x - start_drag_x
        drag_move_total_y := end_drag_y - start_drag_y
        is_dragging := false
    }
}

OnMouseMoveDragListener(x, y) {
    global drag_move_total_x, drag_move_total_y

    if is_dragging {
        drag_move_total_x += x
        drag_move_total_y += y
    }
}

F14 & Insert:: {
    MsgBox(Abs(drag_move_total_x) + Abs(drag_move_total_y))
    if Abs(drag_move_total_x) + Abs(drag_move_total_y) < 100 {
        return
    }
    Send('{MButton up}')
    Send('{F14 up}')

    RestoreMousePosition(true, () => (
        MouseMove(start_drag_x, start_drag_y)
        Send('{LButton down}')
        Sleep(25)
        SendMode('Event')
        MouseMove(start_drag_x + drag_move_total_x, start_drag_y + drag_move_total_y, 2)
        Send('{LButton up}')
    ))
}
