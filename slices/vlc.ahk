#Include ../src/all.ahk

; Alt+Shift+E for screenshot, next frame in VLC
#HotIf WinActive("ahk_exe vlc.exe")

F21:: {
    start := A_TickCount
    bitmap := CGdip.Bitmap.FromScreen()
    time_to_gen_bitmap := A_TickCount - start

    pixels := Array()

    Loop 100 {
        x := A_Index

        Loop 100 {
            y := A_Index

            bitmap.GetPixel(500 + x, 500 + y)
        }
    }

    time_to_read_pixels := A_TickCount - start

    DebugView(Format("format: {}`nTime to bitmap: {}`nTime to pixels: {}",
        bitmap.GetPixelFormat(),
        time_to_gen_bitmap,
        time_to_read_pixels
    ))
}

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

    ; WinRestore(active_id)
    WinMove(left, 0, width, height, active_id)
}

SLIDER_PROGRESS_SEEN := [0xFF287DCC]
SLIDER_PROGRESS_UNSEEN := [0xFFDBDBDB, 0xFFD0D0D0]
SLIDER_PROGRESS_CURSOR := [0xFFC8C8C8]
SLIDER_PROGRESS_CURSOR_WIDTH := 6

holding_slider := false
start_x := -1
start_y := -1

FindProgressPixel(&progress_x, &progress_y) {
    WinGetPos(&vlc_x, &vlc_y, &vlc_width, &vlc_height, 'A')

    progress_bar_scan_line_x := Max(0, vlc_x)
    progress_bar_scan_line_y := vlc_y + vlc_height - 49 ; 49 adds up to the bottom stuff size, even fullscreen

    screen := CGdip.Bitmap.FromScreen(progress_bar_scan_line_x '|' progress_bar_scan_line_y '|' vlc_width '|1')
    found_pixel := vlc_x + BinarySearch(0, screen.GetWidth(), (x) =>
        ArrayIncludes(SLIDER_PROGRESS_UNSEEN, screen.GetPixel(x, 0))
            ? 'less'
            : ArrayIncludes(SLIDER_PROGRESS_SEEN, screen.GetPixel(x, 0))
                ? 'more'
                : true
    )

    found_pixel := Clamp(vlc_x + 72, found_pixel, vlc_x + vlc_width - 72)

    progress_x := found_pixel
    progress_y := progress_bar_scan_line_y
}

; MButton dragging to move video progress bar
Release() {
    global start_x, start_y, holding_slider

    if GetKeyState('F18', 'P') or GetKeyState('Insert', 'P') or GetKeyState('MButton', 'P') {
        return
    }

    Send('{LButton up}')

    MouseMove(start_x, start_y)

    SetTimer(Release, 0)

    holding_slider := false
}

F18::
Insert::
MButton:: {
    global holding_slider, start_x, start_y

    try {
        FindProgressPixel(&progress_x, &progress_y)
    } catch as e {
        MsgBox(e.Message ' at ' e.Line)
    }

    if holding_slider {
        return
    }

    holding_slider := true

    MouseGetPos(&start_x, &start_y)
    WinGetPos(&x, &y, &width, &height, 'A')

    MouseMove(progress_x, progress_y)
    ; MouseMove(x + 66, y + height - 60)
    Send('{LButton down}')

    SetTimer(Release, 50)
}

Pause::
Escape::
BackSpace::WinClose('A')

#HotIf WinActive("ahk_exe vlc.exe") and MouseIsOver("ahk_exe vlc.exe")

WheelUp::+Left
WheelDown::+Right
ScrollLock & WheelUp::!Left
ScrollLock & WheelLeft::!Left
ScrollLock & WheelDown::!Right
ScrollLock & WheelRight::!Right

#HotIf
