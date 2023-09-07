#Requires AutoHotkey v2.0

; DetectHiddenWindows 1
#MaxThreadsPerHotkey 10

; Base all coords on the screen for consistency
; Windowed stuff might need some math
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; Increase hotkey interval (for touchpad scrolling, and other stuff)
A_MaxHotkeysPerInterval := 300

#Include Utils.ahk
#Include Explorer.ahk
#Include Tabbing.ahk
#Include Opera.ahk
#Include Discord.ahk
#Include Notepad++.ahk
#Include PaintNET.ahk
#Include VLC.ahk
#Include AgeOfEmpires.ahk
#Include Illusion.ahk
#Include DST.ahk
#Include BG3.ahk
#Include SV.ahk

; REFERENCE:
; ^ = Ctrl
; + = Shift
; ! = Alt
; # = Win

; ^+d:: {
;     Send("^{End}")
;     Sleep(100)
;     Send(", overalls")
;     Sleep(100)
;     Send("^s")
;     Sleep(100)
;     Send("^w")
; }

; Disable F1, almost always useless and pressed by accident
F1::return

; Alt+F5 to reload the script when developing
!F5::Reload

; Stupid mind shortcut for Alt+A to middle click
!a:: {
    Send("{MButton}")
}

; Ctrl+Alt+{ to send ^
^!{:: {
	Send("{Text}^")
}

; Ctrl+Alt+} to send `
^!}:: {
    Send("{Text}``")
}

; Alt+Shift+T to set the current window always on top
; Useful e.g. with VLC to play in a corner while doing something else
F15 & RButton::
+!T:: {
    ; Set the active window as Last Window (id unused)
    ActiveWindowID := WinExist("A")
    ; Get active window title
    ToppedTitle := WinGetTitle()
    ; -1 to toggle AOT
    WinSetAlwaysOnTop(-1)
    ; Show notif
	TrayTipTimeout(1000, "Topped", ToppedTitle)
}

; Alt+Space to toggle windowed fullscreen mode
F15 & LButton::
!Space:: {
    static WinState := 0
    static LastWinID := 0
    static LastWinX := 0
    static LastWinY := 0
    static LastWinHeight := 0
    static LastWinWidth := 0

    ActiveWinID := WinGetList("A")[1]

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