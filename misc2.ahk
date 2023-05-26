#Requires AutoHotkey v2.0

; DetectHiddenWindows 1
#MaxThreadsPerHotkey 10

; Base all coords on the screen for consistency
; Windowed stuff might need some math
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Screen")

; Increase hotkey interval (for touchpad scrolling, and other stuff)
A_MaxHotkeysPerInterval := 300

global LogsEnabled := false
LogMessage(text) {
    if not LogsEnabled {
        return
    }

    FileAppend(A_now " " text "`n", A_ScriptDir "\log.txt")
}

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

HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion, 1, 3) = "10." {
        A_IconHidden := true
        Sleep 200  ; It may be necessary to adjust this sleep.
        A_IconHidden := false
    }
}

; Alt+Space to toggle windowed fullscreen mode
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

        TrayTip("Hiding taskbar")
        SetTimer(HideTrayTip, -1500)

        WinState := 3
    } else if WinState == 3 {
        Maximize()
		WinShow("ahk_class Shell_TrayWnd")

        WinState := 0
    }
}

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

XButton1 & WheelUp:: {
    Send("{Ctrl down}{Alt down}{Up}{Alt up}{Ctrl up}")
}

XButton1 & WheelDown:: {
    Send("{Ctrl down}{Alt down}{Down}{Alt up}{Ctrl up}")
}

; XButton2 & WheelUp:: {
;     Send("{Alt down}{Up}{Alt up}")
; }

; XButton2 & WheelDown:: {
;     Send("{Alt down}{Down}{Alt up}")
; }
#HotIf

; Function for dropping a list of file paths into application matched by WindowTitle
DropFiles(window, files) {
    memRequired := 0

    for k, v in files {
        memRequired += StrLen(v) + 1
    }

    hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired + 21)
    dropfiles := DllCall("GlobalLock", "ptr", hGlobal)

    offset := 20
    NumPut("uint", 20, dropfiles, 0)

    for k, v in files {
        StrPut(v, dropfiles + offset, StrLen(v), "utf-8")
        offset += StrLen(v) + 1
    }

    DllCall("GlobalUnlock", "ptr", hGlobal)

    PostMessage(0x233, hGlobal, 0,, window)
    DllCall("GlobalFree", "ptr", hGlobal)
}

GetSelectedKKManager() {
    WinX := 0
    WinY := 0
    WinW := 0
    WinH := 0
    OldMouseX := 0
    OldMouseY := 0
    ManagerWindowID := 0

    MouseGetPos(&OldMouseX, &OldMouseY, &ManagerWindowID)
	WinGetPos(&WinX, &WinY, &WinW, &WinH, "ahk_id " ManagerWindowID)
	WinTitle := WinGetTitle("ahk_id " ManagerWindowID)

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
		return ("C:\Users\Doru\Downloads\Pirated\ISL\KKS\UserData\chara\reflection\" A_Clipboard)
    } else {
		return ("C:\Users\Doru\Downloads\Pirated\ISL\HS2\UserData\chara\reflection\" A_Clipboard)
    }
}

DropSelectedKKManager() {
	FileList := [ GetSelectedKKManager() ]

    GameExists := WinExist("ahk_class UnityWndClass")

    if not GameExists {
        return
    }

	DropFiles("ahk_class UnityWndClass", FileList)
    ; Activate after drop, due to lag
    ; (prefer looking at KKM for a few seconds over unresponsive unity)
    WinActivate("ahk_class UnityWndClass")

    ; Redraw game window a few times to wait for responsiveness,
    ; then send ctrl+u to toggle clothing state, sleep, and send to toggle it back
    if true {
        return
    }
    WinRedraw("ahk_class UnityWndClass")
    WinRedraw("ahk_class UnityWndClass")
    Send("{Ctrl down}u{Ctrl up}")
    WinRedraw("ahk_class UnityWndClass")
    Sleep(150)
    WinRedraw("ahk_class UnityWndClass")
    Send("{Ctrl down}u{Ctrl up}")
}

MouseIsOver(WinTitle) {
    MouseGetPos(,, &WindowID)

    return WinExist(WinTitle " ahk_id " WindowID)
}

#HotIf WinActive("ahk_exe KKManager.exe")
Space:: {
    DropSelectedKKManager()
}

#HotIf WinActive("ahk_exe KKManager.exe") or MouseIsOver("ahk_exe KKManager.exe")
XButton1 & LButton:: {
    Click()
    DropSelectedKKManager()
}

XButton1 & RButton:: {
    Click()
    filepath := GetSelectedKKManager()

    attrs := FileGetAttrib(filepath)

    truepath := ExecPS("Get-Item -Path '" filepath "' | Select-Object -ExpandProperty Target")
    truefilename := ""
    truedir := ""

    ; Run(A_ComSpec " /c `"explorer.exe /select,\`"" StrReplace(truepath, "\", "\\") "\`"`"", , "Hide")

    SplitPath(truepath, &truefilename, &truedir)
    Run(Format("{} /c explorer.exe `"{}`"", A_ComSpec, truedir), , "Hide")

    WinWaitActive("ahk_exe explorer.exe")
    Send(truefilename)
}
#HotIf

ExecPS(command) {
    shell := ComObject("WScript.Shell")
    ; exec := shell.Exec("powershell -Command `"" command "`"")
    ; return exec.StdOut.ReadAll()
    exec := shell.Run("powershell -Command `"" command "`" | clip", 0, True)

    return Trim(A_Clipboard, ' `t`n`r')
}

#HotIf WinActive("ahk_exe KoikatsuSunshine.exe")
XButton1 & LButton:: {
    ; Toggle pov
    Send("{Backspace}")
}
#HotIf

#HotIf WinActive("ahk_exe StudioNEOV2.exe") or WinActive("ahk_exe HoneySelect2.exe")
XButton1 & LButton:: {
    ; Toggle pov
    Send(",")
}

XButton1 & MButton:: {
    ; Reset field of view
    Send("´")
}

global DownCount := 0
global UpCount := 0

XButton1 & WheelDown:: {
    global
    DownCount := DownCount + 1
    LogMessage("DownCount++ " DownCount)

    Send("{¿ down}")
    Sleep(50)

    DownCount := DownCount - 1
    LogMessage("DownCount-- " DownCount)

    if DownCount == 0 {
        Send("{¿ up}")
    }
}

XButton1 & WheelUp:: {
    global
    UpCount := UpCount + 1
    LogMessage("UpCount++ " UpCount)

    Send("{+ down}")
    Sleep(50)

    UpCount := UpCount - 1
    LogMessage("UpCount-- " UpCount)

    if UpCount == 0 {
        Send("{+ up}")
    }
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

global HOLDING_TOGGLE := false
global WHEEL_TABULATING := false

TurnWheelTabbingOn() {
    global

    HOLDING_TOGGLE := true
}

TurnWheelTabbingOff() {
    global

    HOLDING_TOGGLE := false

    if WHEEL_TABULATING {
        WHEEL_TABULATING := false
        Send("{Alt up}")
    }
}

; Remap some alt/ctrl + arrow key shortcuts to tab rotating
#HotIf WinActive("ahk_exe opera.exe")
XButton1::
!Right:: {
	Send("{Ctrl down}{Tab}{Ctrl up}")
}

!Left:: {
	Send("{Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}")
}

XButton2:: {
    TurnWheelTabbingOn()
}

XButton2 up:: {
    if not WHEEL_TABULATING {
        Send("{Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}")
    }

    TurnWheelTabbingOff()
}

^+Up:: {
	Send("{Ctrl down}{Tab}{Ctrl up}")
}

^+Down:: {
	Send("{Ctrl down}{Shift down}{Tab}{Shift up}{Ctrl up}")
}
#HotIf

~XButton2:: {
    TurnWheelTabbingOn()
}

~XButton2 up:: {
    TurnWheelTabbingOff()
}

~WheelDown:: {
    global

    if HOLDING_TOGGLE {
        WHEEL_TABULATING := true
        Send("{Alt down}{Tab}")
    }
}

~WheelUp:: {
    global

    if HOLDING_TOGGLE {
        WHEEL_TABULATING := true
        Send("{Alt down}{Shift down}{Tab}{Shift up}")
    }
}