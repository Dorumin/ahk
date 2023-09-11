; This file contains some general windowing tools
; Mostly for fullscreening windowed apps that don't support it, by and setting any window as always on top.

; Set the active window as always on top
; Useful with, for example, VLC to make it play in a corner while doing something else
; Make sure to combine it with ctrl+h for a minified viewer
; +!T::
F15 & RButton:: {
    ; Set the active window as Last Window (id unused)
    ActiveWindowID := WinExist("A")
    ; Get active window title
    ToppedTitle := WinGetTitle()
    ; -1 to toggle AOT
    WinSetAlwaysOnTop(-1)
    ; Show notif
	TrayTipTimeout(1000, "Topped", ToppedTitle)
}

; Toggle windowed fullscreen mode for apps that don't support it
; (or I otherwise don't wanna bother with alt+enter, though that might be DX11 fullscreen)
; !Space::
F15 & LButton:: {
    static WinState := 0
    static LastWinID := 0
    static LastWinX := 0
    static LastWinY := 0
    static LastWinHeight := 0
    static LastWinWidth := 0

    ActiveWinID := WinExist('A')

    if ActiveWinID != LastWinID {
        LastWinID := ActiveWinID
        WinState := 0
    }

    Minimize() {
        WinGetPos(&LastWinX, &LastWinY, &LastWinWidth, &LastWinHeight, ActiveWinID)
        WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, ActiveWinID)
        WinSetStyle("-0x40000", ActiveWinID) ; WS_SIZEBOX
        WinSetStyle("-0x800000", ActiveWinID) ; WS_BORDER
        WinSetStyle("-0x400000", ActiveWinID) ; WS_DLGFRAME
    }

    Maximize() {
        WinMove(LastWinX, LastWinY, LastWinWidth, LastWinHeight, ActiveWinID)
        WinSetStyle("+0x40000", ActiveWinID) ; WS_SIZEBOX
        WinSetStyle("+0x800000", ActiveWinID) ; WS_BORDER
        WinSetStyle("+0x400000", ActiveWinID) ; WS_DLGFRAME
    }

    if WinState == 0 {
        Minimize()

        WinState := 1
    } else if WinState == 1 {
        Maximize()

        WinState := 2
    } else if WinState == 2 {
        Minimize()
		WinHide("ahk_class Shell_TrayWnd")

        TrayTipTimeout(1000, "Hiding taskbar")

        WinState := 3
    } else if WinState == 3 {
        Maximize()
		WinShow("ahk_class Shell_TrayWnd")

        WinState := 0
    }
}