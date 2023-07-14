#Include Utils.ahk

; In KKManager, the file path of the selected card
; Hardcoded for reflections in specific game paths
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
	Send("{Home}")

    ; Set tab focus on 2nd text field on KKS, 3rd on HS2
	if InStr(WinTitle, "[KoikatsuSunshine]") {
		Send("{Down}{Down}")
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

; Reusable fn for getting the selected card path and dropping it into the Unity game
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

#HotIf WinActive("ahk_exe KKManager.exe") or MouseIsOver("ahk_exe KKManager.exe")
XButton1::
F14::
MButton:: {
    Click()
    DropSelectedKKManager()
}

XButton2::
Home & MButton:: {
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

#HotIf WinActive("ahk_exe KoikatsuSunshine.exe") or WinActive("ahk_exe CharaStudio.exe")
$F1::Send("{F1}")

XButton1::
F14:: {
    try {
        WinActivate('ahk_exe KKManager.exe')
        RestoreMousePosition(() => Click(50, 10))
        Send('{Esc}')
    }
}

F13::BackSpace
F18::Space
#HotIf

#HotIf WinActive("ahk_exe StudioNEOV2.exe") or WinActive("ahk_exe HoneySelect2.exe")
F13:: {
    ; Toggle pov
    Send(",")
}

#HotIf WinActive("ahk_exe StudioNEOV2.exe") or WinActive("ahk_exe HoneySelect2.exe") or WinActive("ahk_exe KoikatsuSunshine.exe") or WinActive("ahk_exe CharaStudio.exe")
Home & MButton:: {
    ; Reset field of view
    Send("´")
}

Home & RButton:: {
    Send("{Raw}}")
}

global DownCount := 0
global UpCount := 0

Home & WheelDown:: {
    global
    DownCount := DownCount + 1
    LogMessage("DownCount++ " DownCount)

    Send("{+ down}")
    Sleep(100)

    DownCount := DownCount - 1
    LogMessage("DownCount-- " DownCount)

    if DownCount == 0 {
        Send("{+ up}")
    }
}

Home & WheelUp:: {
    global
    UpCount := UpCount + 1
    LogMessage("UpCount++ " UpCount)

    Send("{¿ down}")
    Sleep(100)

    UpCount := UpCount - 1
    LogMessage("UpCount-- " UpCount)

    if UpCount == 0 {
        Send("{¿ up}")
    }
}
#HotIf