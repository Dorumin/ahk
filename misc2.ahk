#Requires AutoHotkey v2.0

; DetectHiddenWindows 1

; Base all coords on the screen for consistency
; Windowed stuff might need some math
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; REFERENCE:
; Ctrl = ^
; Shift = +
; Alt = !

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
+!T:: {
    ; Get active window title
    ToppedTitle := WinGetTitle("A")
    ; -1 to toggle AOT
    WinSetAlwaysOnTop(-1, "A")
    ; Show notif
	TrayTip("Topped", ToppedTitle)
}

; Alt+Space to toggle fullscreen mode
!Space:: {
    static WinState := false
    static LastWinID := 0
    static LastWinX := 0
    static LastWinY := 0
    static LastWinHeight := 0
    static LastWinWidth := 0

    ActiveWinID := WinGetList("A")[1]

    if ActiveWinID != LastWinID {
        LastWinID := ActiveWinID
        WinState := false
    }

    if WinState == false {
        WinGetPos(&LastWinX, &LastWinY, &LastWinWidth, &LastWinHeight, LastWinID)
        WinMove(0, 0, A_ScreenWidth, A_ScreenHeight, ActiveWinID)
        WinSetStyle("-0x40000", ActiveWinID) ; WS_SIZEBOX
        WinSetStyle("-0x800000", ActiveWinID) ; WS_BORDER
        WinSetStyle("-0x400000", ActiveWinID) ; WS_DLGFRAME
		; WinHide("ahk_class Shell_TrayWnd")

        WinState := true
    } else {
        WinMove(LastWinX, LastWinY, LastWinWidth, LastWinHeight, ActiveWinID)
        WinSetStyle("+0x40000", ActiveWinID) ; WS_SIZEBOX
        WinSetStyle("+0x800000", ActiveWinID) ; WS_BORDER
        WinSetStyle("+0x400000", ActiveWinID) ; WS_DLGFRAME
		; WinShow("ahk_class Shell_TrayWnd")

        WinState := false
    }
}

; Remap some alt/ctrl + arrow key shortcuts to tab rotating
#HotIf WinActive("ahk_exe opera.exe")
^+Up:: {
	Send("{Ctrl down}{Tab}{Ctrl up}")
}

^+Down:: {
	Send("{Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}")
}

!Right:: {
	Send("{Ctrl down}{Tab}{Ctrl up}")
}

!Left:: {
	Send("{Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}")
}
#HotIf

; Alt+Shift+E for screenshot, next frame in VLC
#HotIf WinActive("ahk_exe vlc.exe")
!+e:: {
	Send("{Shift down}s{Shift up}")
	Sleep(150)
	Send("e")
}
#HotIf

; Disable Ctrl+R in Discord (refresh)
#HotIf WinActive("ahk_exe Discord.exe")
^r:: {
	; do nothing
}

; Disable Ctrl+P in Discord (open pins)
^p:: {
    ; do nothing
}

; Disable Ctrl+Shift+A in Discord (collapse all categories)
^+a:: {
	; do nothing
}
#HotIf


DropFiles(window, files) {
    ; MsgBox("files " files[1])

    memRequired := 0

    for k, v in files {
        memRequired += StrLen(v) + 1
    }

    hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired + 21)
    dropfiles := DllCall("GlobalLock", "ptr", hGlobal)

    ; NumPut(offset := 20, dropfiles + 0, 0, "uint")
    ; MsgBox("dropfiles " dropfiles " type " Type(dropfiles))
    offset := 20
    NumPut("uint", 20, dropfiles + 0, 0)

    for k, v in files {
        StrPut(v, dropfiles + offset, StrLen(v), "utf-8")
        offset += StrLen(v) + 1
    }

    DllCall("GlobalUnlock", "ptr", hGlobal)

    PostMessage(0x233, hGlobal, 0,, window)
    DllCall("GlobalFree", "ptr", hGlobal)
}

DropSelectedKKManager() {
	FileList := []
    WinX := 0
    WinY := 0
    WinW := 0
    WinH := 0
    OldMouseX := 0
    OldMouseY := 0

    MouseGetPos(&OldMouseX, &OldMouseY)
	WinGetPos(&WinX, &WinY, &WinW, &WinH, "A")
	WinTitle := WinGetTitle("A")

	WhereImageX := WinX + WinW - 60
	WhereImageY := WinY + WinH - 200

	MouseMove(WhereImageX, WhereImageY, 0)
	Click(WhereImageX, WhereImageY)
	MouseMove(OldMouseX, OldMouseY, 0)

	; Set tab focus on a text field
	Send("{Tab}{Enter}{Tab}{Enter}{Tab}{Enter}")
	; Set tab focus on topmost text field
	; Send("{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}{Up}")
	Send("{Home}")

    ; Set tab focus on 2nd text field on KKS, 3rd on HS2
	if InStr(WinTitle, "[KoikatsuSunshine]") {
		Send("{Down}")
    } else {
		Send("{Down}{Down}")
    }

    ; Empty clipboard, set tab focus on text field content, copy
    A_Clipboard := ""
	Send("{Tab}")
	Send("{Ctrl down}C{Ctrl up}")
    ClipWait(2)

	if InStr(WinTitle, "[KoikatsuSunshine]") {
		FileList.Push("C:\\Users\\Doru\\Downloads\\Pirated\\ISL\\KKS\\UserData\\chara\\reflection\\" A_Clipboard)
    } else {
		FileList.Push("C:\\Users\\Doru\\Downloads\\Pirated\\ISL\\HS2\\UserData\\chara\\reflection\\" A_Clipboard)
    }

	DropFiles("ahk_class UnityWndClass", FileList)
    WinActivate("ahk_class UnityWndClass") ; Activate after drop, due to lag

    ; Redraw game window a few times to wait for responsiveness,
    ; then send ctrl+u to toggle clothing state, sleep, and send to toggle it back
    WinRedraw("ahk_class UnityWndClass")
    WinRedraw("ahk_class UnityWndClass")
    Send("{Ctrl down}u{Ctrl up}")
    WinRedraw("ahk_class UnityWndClass")
    Sleep(150)
    WinRedraw("ahk_class UnityWndClass")
    Send("{Ctrl down}u{Ctrl up}")
}

#HotIf WinActive("ahk_exe KKManager.exe")
Space:: {
    DropSelectedKKManager()
}

XButton1:: {
    Click()
    DropSelectedKKManager()
}
#HotIf

#HotIf WinActive("ahk_exe KoikatsuSunshine.exe")
XButton1:: {
    Send("{Backspace}")
}
#HotIf

#HotIf WinActive("ahk_exe explorer.exe")
~LButton:: {
    x := 0
    y := 0
	MouseGetPos(&x, &y)

	if (y < 4) {
		MouseMove(x, 4, 0)
		Click(x, 4)
	}
}
#HotIf