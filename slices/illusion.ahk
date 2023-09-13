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

; GroupAdd('KKGameplay', 'ahk_exe KoikatsuSunshine.exe')
; GroupAdd('KKStudio', 'ahk_exe CharaStudio.exe')
; GroupAddMultiple('KKAny', 'ahk_group KKGameplay', 'ahk_group KKStudio')
; GroupAdd('HS2Gameplay', 'ahk_exe HoneySelect2.exe')
; GroupAdd('HS2Studio', 'ahk_exe StudioNEOV2.exe')
; GroupAddMultiple('HS2Any', 'ahk_group HS2Gameplay', 'ahk_group HS2Studio')
; GroupAddMultiple('IllusionGameplay', 'ahk_group KKGameplay', 'ahk_group HS2Gameplay')
; GroupAddMultiple('IllusionStudio', 'ahk_group KKStudio', 'ahk_group HS2Studio')
; GroupAddMultiple('IllusionAny', 'ahk_group KKAny', 'ahk_group HS2Any')

GroupAddTree({
    IllusionAny: {
        KKAny: {
            KKGameplay: 'ahk_exe KoikatsuSunshine.exe',
            KKStudio: 'ahk_exe CharaStudio.exe'
        },
        HS2Any: {
            HS2Gameplay: 'ahk_exe HoneySelect2.exe',
            HS2Studio: 'ahk_exe StudioNEOV2.exe'
        }
    },
    IllusionGameplay: ['KKGameplay', 'HS2Gameplay'],
    IllusionStudio: ['KKStudio', 'HS2Studio']
})

; KK Manager
#HotIf WinActive("ahk_exe KKManager.exe") or MouseIsOver("ahk_exe KKManager.exe")
F16::
MButton:: {
    Click()
    DropSelectedKKManager()
}

Insert::
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
#HotIf WinActive("ahk_group KKAny")
F1::F1

F16:: {
    try {
        WinActivate('ahk_exe KKManager.exe')
        RestoreMousePosition(true, () => Click(50, 10))
        Send('{Esc}')
    }
}

F17::BackSpace
F18::Space

Insert::LongPress('XButton2', 50)
Pause::LongPress('XButton2', 500)
#HotIf

; HS2
#HotIf WinActive("ahk_group HS2Any")

F17::,

F18::Space
#HotIf

; All games, all studios
#HotIf WinActive("ahk_group IllusionAny")
; Reset field of view
ScrollLock & MButton::Send("{ScrollLock up}´")

; Reset camera roll (not yaw, not pitch)
ScrollLock & RButton::Send("{ScrollLock up}{Raw}}")

; Scene effects
F20:: {
    RestoreMousePosition(true, SetSceneEffects)
    SetSceneEffects() {
        color := PixelGetColor(20, 222, "RGB")

        ; Inactive color
        if color == "0x464646" {
            MouseMove(20, 222)
            LongPress("LButton", 50, 150)
        }

        scene_effects_color := PixelGetColor(120, 132, "RGB")

        if scene_effects_color != "0x006300" {
            MouseMove(120, 132)
            LongPress("LButton", 75, 75)
        }

        MouseMove(595, 35)
        LongPress("LButton", 50, 50)

        dof_color := PixelGetColor(380, 259, 'RGB')

        if dof_color == "0x22FF94" {
            MouseMove(380, 259)
            LongPress("LButton", 35, 100)
        }

        MouseMove(595, 618)
        LongPress("LButton", 50, 50)

        MouseMove(525, 560)
        LongPress("LButton", 75, 75)
        Send('0')
        Send('{Enter}')

        ; Close system menu
        MouseMove(20, 222)
        LongPress("LButton", 50, 150)
    }
}

IsSceneBrowserOpen() {
    return (
        PixelGetColor(1725, 250, 'RGB') == '0x000000' ; Inner close button
        && PixelGetColor(1725, 242, 'RGB') == '0xFFFFFF' ; Outer close button
        && ArrayIncludes(['0x6C6C6C', '0x424242'], PixelGetColor(800, 90, 'RGB')) ; Folder browser; modded
        ; && ArrayIncludes(['0x696868', '0x6A6967', '0x6C6C6A', '0x696866'], PixelGetColor(190, 250, 'RGB')) ; Translucent; useless
        ; && PixelGetColor(1650, 285, 'RGB') == '0xD9D9D9' ; Suspicious; uses buttons on the right. Might have shifted
    )
}

SCENE_SCROLLBAR_COLOR := "0xC4C4C3"
SCENE_SCROLLBAR_X := 1723
SCENE_SCROLLBAR_START_Y := 271
SCENE_SCROLLBAR_END_Y := 900
SCENE_SCROLLBAR_STEP := 3

last_scrollbar_y := -1

SceneBrowserWorker() {
    global last_scrollbar_y

    if not IsSceneBrowserOpen() {
        return
    }

    ; Clear self from timer list
    SetTimer(SceneBrowserWorker, 0)

    ; TrayTipTimeout(1000, Format("cleared worker; current y at {}", last_scrollbar_y))

    if last_scrollbar_y == -1 or last_scrollbar_y == SCENE_SCROLLBAR_START_Y {
        return
    }

    RestoreMousePosition(true, () => (
        MouseMove(SCENE_SCROLLBAR_X, SCENE_SCROLLBAR_START_Y + 1)
        Send('{LButton down}')
        Sleep(150)
        MouseMove(SCENE_SCROLLBAR_X, last_scrollbar_y)
        Sleep(150)
        Send('{LButton up}')
    ))
}

OpenSceneBrowser() {
    color := PixelGetColor(20, 222, "RGB")

    ; Inactive color
    if color = "0x464646" {
        MouseMove(20, 222)
        LongPress("LButton", 50, 50)
    }

    MouseMove(150, 185)
    LongPress("LButton", 50, 50)

    SetTimer(SceneBrowserWorker, 250)
}

SelectSceneInBrowser() {
    global last_scrollbar_y

    LongPress('LButton', 50, 50)
    MouseMove(800, 670)
    LongPress('LButton', 50, 50)

    current_scrollbar_y := SCENE_SCROLLBAR_START_Y

    loop {
        color := PixelGetColor(SCENE_SCROLLBAR_X, current_scrollbar_y, 'RGB')

        if color == SCENE_SCROLLBAR_COLOR {
            last_scrollbar_y := current_scrollbar_y
            break
        }

        current_scrollbar_y += SCENE_SCROLLBAR_STEP

        if current_scrollbar_y > SCENE_SCROLLBAR_END_Y {
            break
        }
    }

    ; TrayTipTimeout(1000, Format("finished scan; current y at {}", current_scrollbar_y))
}

; Open browser
F19:: {
    if IsSceneBrowserOpen() {
        RestoreMousePosition(true, SelectSceneInBrowser)
    } else {
        RestoreMousePosition(true, OpenSceneBrowser)
    }
}

; Stuff for adjusting zoom and roll
global DownCount := 0
global UpCount := 0

zoom_in_holder := KeyHolder(['¿'])
zoom_out_holder := KeyHolder(['+'])

ScrollLock & WheelDown::zoom_out_holder.Pressed()

ScrollLock & WheelUp::zoom_in_holder.Pressed()

tilt_left_holder := KeyHolder(['.'], 100, 300)
tilt_right_holder := KeyHolder(['<'], 100, 300)

tilt_fast_left_holder := KeyHolder(['shift', '.'], 100, 300)
tilt_fast_right_holder := KeyHolder(['shift', '<'], 100, 300)

WheelLeft::tilt_left_holder.Pressed()
WheelRight::tilt_right_holder.Pressed()

ScrollLock & WheelLeft::tilt_fast_left_holder.Pressed()
ScrollLock & WheelRight::tilt_fast_right_holder.Pressed()

; Camera cycling
last_cycle := -1
last_cam := -1

F24:: {
    global last_cycle, last_cam

    if last_cycle == -1 or last_cycle + 10000 < A_TickCount {
        last_cam := 1
    } else {
        last_cam += 1

        if last_cam > 10 {
            last_cam := 1
        }
    }

    last_cycle := A_TickCount

    if last_cam == 10 {
        Send('0')
    } else {
        Send(last_cam)
    }
}
F23:: {
    global last_cycle, last_cam

    if last_cycle == -1 or last_cycle + 10000 < A_TickCount {
        last_cam := 10
    } else {
        last_cam -= 1

        if last_cam < 1 {
            last_cam := 10
        }
    }

    last_cycle := A_TickCount

    if last_cam == 10 {
        Send('0')
    } else {
        Send(last_cam)
    }
}
#HotIf