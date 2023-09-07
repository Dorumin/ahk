#Include Utils.ahk

global POSSIBLE_FILENAME_POSITIONS := [
    3,
    2
]

; In KKManager, the file path of the selected card
; Hardcoded for reflections in specific game paths
GetSelectedKKManager() {
    global POSSIBLE_FILENAME_POSITIONS

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

    RestoreMousePosition(true, () => Click(WhereImageX, WhereImageY))

	; Set tab focus on a text field
	Send("{Tab}{Enter}{Tab}{Enter}{Tab}{Enter}")
	; Set tab focus on topmost text field
	Send("{Home}")
    lastPosition := 1
    filename := ""

    ; Loop through property positions, handling movement as efficiently as needed
    ; then copying the properties to find the first position with a valid png filename
    for position in POSSIBLE_FILENAME_POSITIONS {
        movement := position - lastPosition
        commands := ""

        lastPosition := position

        if movement > 0 {
            commands .= RepeatString("{Down}", movement)
        } else {
            commands .= RepeatString("{Up}", -movement)
        }

        ; MsgBox(Format("movement: {} commands: {}", movement, commands))

        commands .= "{Tab}{Ctrl down}c{Ctrl up}{Enter}"

        A_Clipboard := ""
        Send(commands)
        ClipWait(1)
        filename := A_Clipboard

        if InStr(filename, ".png") {
            break
        } else {
            filename := ""
            ; Sleep(200)
        }
    }

    if filename == "" {
        throw ValueError("No filename found in columns. Check indices, properties")
    }

    switch {
        case InStr(WinTitle, "[KoikatsuSunshine]"):
            return FindFirstExistingFile([
                "C:\Users\Doru\Downloads\Pirated\ISL\KKS\UserData\chara\reflection\" filename,
                "C:\Users\Doru\Downloads\Pirated\ISL\KKS\UserData\chara\female\" filename,
                "C:\Users\Doru\Downloads\Pirated\ISL\KKS\UserData\chara\male\" filename
            ])
        case InStr(WinTitle, "[HoneySelect2]"):
            return FindFirstExistingFile([
                "C:\Users\Doru\Downloads\Pirated\ISL\HS2\UserData\chara\reflection\" filename,
                "C:\Users\Doru\Downloads\Pirated\ISL\HS2\UserData\chara\female\" filename,
                "C:\Users\Doru\Downloads\Pirated\ISL\HS2\UserData\chara\male\" filename
            ])
        default:
            throw TargetError("This KKManager window is for an unrecognized game.")
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

; KK Manager
#HotIf WinActive("ahk_exe KKManager.exe") or MouseIsOver("ahk_exe KKManager.exe")
Media_Prev::
F24::
MButton:: {
    Click()
    DropSelectedKKManager()
}

Media_Next::
ScrollLock & MButton:: {
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

; KKS
#HotIf WinActive("ahk_exe KoikatsuSunshine.exe") or WinActive("ahk_exe CharaStudio.exe")
$F1::Send("{F1}")

Media_Prev::
F24:: {
    try {
        WinActivate('ahk_exe KKManager.exe')
        RestoreMousePosition(true, () => Click(50, 10))
        Send('{Esc}')
    }
}

F21::BackSpace
F23::Space
#HotIf

; HS2
#HotIf WinActive("ahk_exe StudioNEOV2.exe") or WinActive("ahk_exe HoneySelect2.exe")

F21::Send(",")

F23::Space
#HotIf

; All games, all studios
#HotIf WinActive("ahk_exe StudioNEOV2.exe") or WinActive("ahk_exe HoneySelect2.exe") or WinActive("ahk_exe KoikatsuSunshine.exe") or WinActive("ahk_exe CharaStudio.exe")
; Reset field of view
ScrollLock & MButton::Send("´")

; Reset camera roll (not yaw, not pitch)
ScrollLock & RButton:: {
    Send("{ScrollLock up}{Raw}}")
}

; Scene effects
F19:: {
    color := PixelGetColor(20, 222, "RGB")

    ; Inactive color
    if color == "0x464646" {
        MouseMove(20, 222)
        LongPress("LButton", 50, 50)
    }

    scene_effects_color := PixelGetColor(120, 132, "RGB")

    if scene_effects_color != "0x006300" {
        MouseMove(120, 132)
        LongPress("LButton", 50, 50)
    }

    MouseMove(595, 35)
    LongPress("LButton", 50, 50)

    dof_color := PixelGetColor(380, 259, 'RGB')

    if dof_color == "0x22FF94" {
        MouseMove(380, 259)
        LongPress("LButton", 50, 50)
    }

    MouseMove(595, 618)
    LongPress("LButton", 50, 50)

    MouseMove(525, 560)
    LongPress("LButton", 50, 50)
    Send('0')
    Send('{Enter}')
}

; Open browser
F22:: {
    color := PixelGetColor(20, 222, "RGB")

    ; Inactive color
    if color = "0x464646" {
        MouseMove(20, 222)
        LongPress("LButton", 50, 50)
    }

    Click(150, 185)
}

; Stuff for adjusting zoom and roll
global DownCount := 0
global UpCount := 0
global LeftCount := 0
global RightCount := 0

ScrollLock & WheelDown:: {
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

ScrollLock & WheelUp:: {
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

WheelLeft:: {
    global
    LeftCount := LeftCount + 1
    LogMessage("LeftCount++ " LeftCount)

    Send("{< down}")
    Sleep(100)

    LeftCount := LeftCount - 1
    LogMessage("LeftCount-- " LeftCount)

    if LeftCount == 0 {
        Send("{< up}")
    }
}

WheelRight:: {
    global
    RightCount := RightCount + 1
    LogMessage("RightCount++ " RightCount)

    Send("{. down}")
    Sleep(100)

    RightCount := RightCount - 1
    LogMessage("RightCount-- " RightCount)

    if RightCount == 0 {
        Send("{. up}")
    }
}

; Camera cycling

LastCycle := 0
CurrentCam := 0
F18:: {
    global CurrentCam, LastCycle

    if LastCycle < 10000 {
        LastCycle := A_TickCount
    }

    CurrentCam += 1

    if CurrentCam > 10 {
        CurrentCam := 1
    }

    Send(Format("{}", CurrentCam))
}
F16:: {
    global CurrentCam, LastCycle

    if LastCycle < 10000 {
        LastCycle := A_TickCount
    }

    CurrentCam -= 1

    if CurrentCam < 0 {
        CurrentCam := 0
    }

    Send(Format("{}", CurrentCam))
}
#HotIf