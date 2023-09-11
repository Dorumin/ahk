; Alt+Shift+E for screenshot, next frame in VLC
#HotIf WinActive("ahk_exe vlc.exe")

F19::
!+e:: {
    ; Delay might be a little short for 4k video, but it works okay
    ; as long as MaxThreadsPerHotkey is set to 1, or it's otherwise buffered
    ; Could always just use a global bool to prevent simultaneous runs
	Send("+s")
	Sleep(100)
	Send("e")
}

F16:: {
    active_id := WinExist("A")

    if WinGetStyle(active_id) & 0xC00000 {
        Send("^h")
        WinSetStyle("-0xC00000", active_id) ; WS_CAPTION
    } else {
        WinSetStyle("+0xC00000", active_id) ; WS_CAPTION
    }
}

F17:: {
    active_id := WinExist('A')
    is_not_minimal := WinGetStyle(active_id) & 0xC00000

    swidth := A_ScreenWidth
    sheight := A_ScreenHeight
    width := swidth / 2
    height := sheight / 2
    left := swidth - width

    if is_not_minimal {
        height += 18 + 34 + 26 + 36
    }

    WinMove(left, 0, width, height, 'A')
}

; MButton dragging to move video progress bar
holding_slider := false
start_x := -1
start_y := -1

F22::
MButton:: {
    global holding_slider, start_x, start_y

    if holding_slider {
        return
    }

    holding_slider := true
    MouseGetPos(&start_x, &start_y)

    WinGetPos(&x, &y, &width, &height, 'A')

    MouseMove(x + 66, y + height - 60)
    Send('{LButton down}')
}

F22 up::
MButton up:: {
    global holding_slider, start_x, start_y
    Send('{LButton up}')

    MouseMove(start_x, start_y)

    holding_slider := false
}

#HotIf
