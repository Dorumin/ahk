#Include ../src/all.ahk

global POSSIBLE_FILENAME_POSITIONS := [
    4,
    3,
    2
]

global coming_from_win_id := 0

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
        case InStr(WinTitle, "KoikatsuSunshine"):
            return FindFirstExistingFile([
                "D:\Games\IS\KKS\UserData\chara\reflection\" filename,
                "D:\Games\IS\KKS\UserData\chara\recent\" filename,
                "D:\Games\IS\KKS\UserData\chara\female\" filename,
                "D:\Games\IS\KKS\UserData\chara\male\" filename,
            ])
        case InStr(WinTitle, "HoneySelect2"):
            return FindFirstExistingFile([
                "D:\Games\IS\HS2\UserData\chara\reflection\" filename,
                "D:\Games\IS\HS3\UserData\chara\reflection\" filename,
                "D:\Games\IS\HS2\UserData\chara\recent\" filename,
                "D:\Games\IS\HS2\UserData\chara\female\" filename,
                "D:\Games\IS\HS2\UserData\chara\export\" filename,
                "D:\Games\IS\HS2\UserData\chara\male\" filename,
            ])
        default:
            throw TargetError("This KKManager window is for an unrecognized game.")
    }
}

; Relinks a file_path symlink (or file) into a /recent/ tracking folder
TrackRecentSelected(file_path) {
    ; Resolve symlink path. This works on regular files too
    file_target := Trim(ExecPS3("(Get-ChildItem '" file_path "').Target"), ' `n`t`r')
    ; Get the stem past chara for the target
    file_target_stem := RegExReplace(file_target, '.+?\\chara\\\w+\\', '')
    ; Get the static prefix up to chara for the target
    chara_prefix := RegExReplace(file_target, '(.+?\\chara)\\.+', '$1')
    ; Map the stem to lowercase, turn into valid component by replacing separators
    recent_stem := RegExReplace(StrLower(file_target_stem), '\\|/', '.')
    ; Reconstruct path with prefix
    recent_path := chara_prefix '\recent\' recent_stem

    ; Relink target to new static location in /recent/
    ExecPS3('cmd /c mklink "' recent_path '" "' file_target '"')
}

; Reusable fn for getting the selected card path and dropping it into the Unity game
DropSelectedKKManager(track) {
    global coming_from_win_id

    game_window_ids := WinGetList("ahk_class UnityWndClass")
    ; game_window_id := WinExist("ahk_class UnityWndClass")
    file_path := GetSelectedKKManager()
    file_list := [ file_path ]

    if ArrayIncludes(game_window_ids, coming_from_win_id) {
        game_window_ids := [ coming_from_win_id ]
    }

    if track {
        TrackRecentSelected(file_path)
    }

    for game_window_id in game_window_ids {
        DropFiles(game_window_id, file_list)
        ; Focus game window after drop
        WinActivate(game_window_id)
    }
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
F19:: {
    RestoreMousePosition(true, () => Click(1340, 620))
    Click()
    DropSelectedKKManager(true)
}

Pause:: {
    RestoreMousePosition(true, () => Click(1340, 620))
    Click()
    DropSelectedKKManager(false)
}

ScrollLock & F19:: {
    Send('{ScrollLock up}')
    RestoreMousePosition(true, () => Click(1300, 620))
    Click()
    file_path := GetSelectedKKManager()
    file_target := ExecPS3("(Get-ChildItem '" file_path "').Target")

    if file_target && file_target != "" {
        ; Target is a symlink, we can delete it
        LogMessage(Format("Deleted symlink: {}`nPointed to: {}", file_path, file_target))
        FileRecycle(file_target)
    } else {
        ; Target is not a symlink, delete anyways...?
        LogMessage(Format("Deleted file, was not a symlink: {}", file_path))
        FileRecycle(file_path)
    }
}

Insert::
ScrollLock & MButton:: {
    Click()
    filepath := GetSelectedKKManager()

    attrs := FileGetAttrib(filepath)

    truepath := ExecPS3("Get-Item -Path '" filepath "' | Select-Object -ExpandProperty Target")
    truefilename := ""
    truedir := ""

    ; Run(A_ComSpec " /c `"explorer.exe /select,\`"" StrReplace(truepath, "\", "\\") "\`"`"", , "Hide")

    SplitPath(truepath, &truefilename, &truedir)
    Run(Format("{} /c explorer.exe `"{}`"", A_ComSpec, truedir), , "Hide")

    WinWaitActive("ahk_exe explorer.exe")
    Send(truefilename)
}
#HotIf

#HotIf WinActive("ahk_group IllusionAny")
F19:: {
    global coming_from_win_id

    try {
        coming_from_win_id := WinActive()

        WinActivate('ahk_exe KKManager.exe')
        ; RestoreMousePosition(true, () => Click(50, 10))
        ; Send('{Esc}')
    }
}
#HotIf

; KKS
#HotIf WinActive("ahk_group KKAny")

F18::Space

; Breaks in charamaker, so make explicit with mod key
ScrollLock & F17::Send('{ScrollLock up}{BackSpace}')

; Stuff for adjusting zoom and roll
zoom_in_holder := KeyHolder(['¿'])
zoom_out_holder := KeyHolder(['+'])

ScrollLock & WheelDown::zoom_out_holder.Pressed()

ScrollLock & WheelUp::zoom_in_holder.Pressed()

#HotIf

#HotIf WinActive('ahk_group KKStudio')

; Breaks in charamaker
F17::BackSpace

#HotIf

:RC1*:cusr::{{user}}
:RC1*:cchr::{{char}}

; HS2
#HotIf WinActive("ahk_group HS2Any")
F17::,

F18::Space

ScrollLock & WheelUp::zoom_out_holder.Pressed()

ScrollLock & WheelDown::zoom_in_holder.Pressed()

#HotIf

#HotIf WinActive("ahk_group HS2Gameplay")

F16:: {
    LongPress('LButton', 50, 250)

    MouseMove(1825, 825)
    LongPress('LButton', 50, 50)
}

#HotIf

#HotIf WinActive("ahk_group KKGameplay")

F16:: {
    LongPress('LButton', 50, 250)

    MouseMove(585, 1035)
    LongPress('LButton', 50, 50)
}

Pause:: {
    RestoreMousePosition(true, PerformChange)
    PerformChange() {
        Click(730, 69)
        Sleep(300)

        annoying_piece_of_shit_coordinates := [
            88,
            120,
            151,
            183,
            214,
            246,
            277
        ]
        selected_color := '0xE78A70'
        default_color := '0x0067BB'
        selected_index := -1
        next_index := -1

        for index, y in annoying_piece_of_shit_coordinates {
            color := PixelGetColor(725, y, 'RGB')

            if color == selected_color {
                selected_index := index
                break
            }
        }

        if selected_index == -1 {
            next_index := annoying_piece_of_shit_coordinates.Length
        } else if selected_index == 1 {
            next_index := annoying_piece_of_shit_coordinates.Length
        } else {
            next_index := selected_index - 1
        }

        next_y := annoying_piece_of_shit_coordinates[next_index]

        Click(725, next_y)

        Sleep(100)
    }
}

Insert:: {
    ; MsgBox('next')

    RestoreMousePosition(true, PerformChange)
    PerformChange() {
        Click(730, 69)
        Sleep(300)

        annoying_piece_of_shit_coordinates := [
            88,
            120,
            151,
            183,
            214,
            246,
            277
        ]
        selected_color := '0xE78A70'
        default_color := '0x0067BB'
        selected_index := -1
        next_index := -1

        for index, y in annoying_piece_of_shit_coordinates {
            color := PixelGetColor(725, y, 'RGB')

            if color == selected_color {
                selected_index := index
                break
            }
        }

        if selected_index == -1 {
            next_index := 1
        } else if selected_index == annoying_piece_of_shit_coordinates.Length {
            next_index := 1
        } else {
            next_index := selected_index + 1
        }

        next_y := annoying_piece_of_shit_coordinates[next_index]

        Click(725, next_y)

        Sleep(100)
    }
}

; LockOn can't be rebound
ScrollLock & Insert::Send('{ScrollLock up}{XButton2 down}')
ScrollLock & Insert up::Send('{ScrollLock up}{XButton2 up}')

#HotIf

#HotIf WinActive("ahk_group IllusionAny")

F1::Send('{F1}')

Pause::F12
F23 & LButton::F5

; Reset field of view
ScrollLock & MButton::Send("{ScrollLock up}´")

; Reset camera roll (not yaw, not pitch)
ScrollLock & RButton::Send("{ScrollLock up}{Raw}}")

tilt_left_holder := KeyHolder(['.'], 100, 300)
tilt_right_holder := KeyHolder(['<'], 100, 300)

tilt_fast_left_holder := KeyHolder(['shift', '.'], 100, 300)
tilt_fast_right_holder := KeyHolder(['shift', '<'], 100, 300)

WheelLeft::tilt_left_holder.Pressed()
WheelRight::tilt_right_holder.Pressed()

ScrollLock & WheelLeft::tilt_fast_left_holder.Pressed()
ScrollLock & WheelRight::tilt_fast_right_holder.Pressed()

#HotIf

#HotIf WinActive('ahk_exe WildLifeC-Win64-Shipping.exe')

; F17::Send('h')

wl_f18_held := false
F18:: {
    global wl_f18_held := true
    Send('{w down}')
}
F18 up:: {
    global wl_f18_held := false
    Send('{w up}')
}

devices := AHI.GetDeviceList()
for index, device in devices {
    if device.IsMouse {
        AHI.SubscribeMouseButtons(device.id, false, LeftMouseCb)
        LeftMouseCb(which, held) {
            if false {
                return
            }

            if wl_f18_held and which == 0 {
                if held {
                    Send('{Shift down}')
                } else {
                    Send('{Shift up}')
                }
            } else if wl_f18_held and which == 1 {
                if held {
                    Send('{Space down}')
                } else {
                    Send('{Space up}')
                }
            }
        }
    }
}

F16::e
F16 & LButton::i
F16 & RButton::Send('r')
F16 & Pause::Send('t')
F16 & Insert::Send('f')
F16 & MButton::Send('y')
F16 & WheelRight::SendQueue('{Shift down}', 50, 'l', 50, '{Shift up}')

F17::H
F17 & LButton::a
F17 & RButton::d
F17 & Pause::w
F17 & Insert::s
F17 & WheelLeft::q
F17 & WheelRight::e

F19 & LButton::Send('y')

F24 & RButton::Send('{Tab}')
F24 & Pause:: {
    Send('{Escape}')
    PixelWait(315, 960, [0xa6a6a6, 0x898989, 0x989898, 0x999999], -1, 3)
    Click(315, 960)
    PixelWait(750, 595, [0x3f3f3f, 0x505050], -1, 3)
    ; Click(750, 595)
    MouseMove(750, 595)
    PixelWait(225, 655, [0x999999], -1, 3)
    Click(225, 655)
    PixelWait(845, 740, [0xe3e0cf, 0xdedbc7], -1, 3)
    Click(845, 740)
}

#HotIf

#HotIf WinActive("ahk_group IllusionStudio")

; LockOn can't be rebound
Insert::Send('{XButton2 down}')
Insert up::Send('{XButton2 up}')

ScrollLock & Insert::Send('{ScrollLock up}f')

; Scene effects
F20:: {
    RestoreMousePosition(true, SetSceneEffects)
    SetSceneEffects() {
        ; Open system list menu
        color := PixelGetColor(20, 222, "RGB")

        ; Inactive color
        if color == "0x464646" {
            MouseMove(20, 222)
            LongPress("LButton", 50, 150)
            Sleep(250)
        }

        ; Open system effects menu
        scene_effects_color := PixelGetColor(120, 132, "RGB")

        if scene_effects_color != "0x006300" { ; 605f5b
            MouseMove(120, 132)
            LongPress("LButton", 75, 75)
        }

        ; Scroll to top
        MouseMove(595, 35)
        LongPress("LButton", 50, 50)

        ; Kill depth of field if enabled
        dof_color := PixelGetColor(380, 259, 'RGB')

        if dof_color == "0x22FF94" {
            MouseMove(380, 259)
            LongPress("LButton", 35, 50)
        }

        ; Scroll to bottom
        MouseMove(595, 618)
        LongPress("LButton", 50, 150)

        ; Set shadow type to A if set to B
        sta_color := PixelGetColor(385, 315, 'RGB')

        if sta_color == "0x5D5D5D" {
            MouseMove(385, 315)
            LongPress("LButton", 35, 100)
        }

        ; Kill near clip plane
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
        && ( ; Folder browser; modded
            ArrayIncludes(['0x6C6C6C', '0x424242'], PixelGetColor(800, 90, 'RGB'))
            || PixelGetColor(100, 950, 'RGB') =='0x545454'
         )
        ; && ArrayIncludes(['0x696868', '0x6A6967', '0x6C6C6A', '0x696866'], PixelGetColor(190, 250, 'RGB')) ; Translucent; useless
        ; && PixelGetColor(1650, 285, 'RGB') == '0xD9D9D9' ; Suspicious; uses buttons on the right. Might have shifted
    )
}

SCENE_SCROLLBAR_COLOR := 0xFFC4C4C3
SCENE_SCROLLBAR_X := 1723
SCENE_SCROLLBAR_START_Y := 271
SCENE_SCROLLBAR_END_Y := 900
SCENE_SCROLLBAR_STEP := 3

last_scrollbar_y := PersistedValue({
    key: 'last-scrollbar-y',
    value: -1,
    serialize: (n) => String(n),
    deserialize: (s) => Number(s)
})
last_green_tile_y := PersistedValue({
    key: 'last-green-tile-y',
    value: -1,
    serialize: (n) => String(n),
    deserialize: (s) => Number(s)
})

SceneBrowserWorker() {
    if not IsSceneBrowserOpen() {
        return
    }

    ; Clear self from timer list
    SetTimer(SceneBrowserWorker, 0)

    ; TrayTipTimeout(1000, Format("cleared worker; current y at {}", last_scrollbar_y.Get()))

    if last_scrollbar_y.Get() == -1 or last_scrollbar_y.Get() == SCENE_SCROLLBAR_START_Y {
        return
    }

    BarManip() {
        MouseMove(SCENE_SCROLLBAR_X, SCENE_SCROLLBAR_START_Y + 1)
        Send('{LButton down}')
        Sleep(50)
        Send('{LButton down}')
        Sleep(50)
        MouseMove(SCENE_SCROLLBAR_X, last_scrollbar_y.Get() + 1)
        MouseMove(SCENE_SCROLLBAR_X - 1, last_scrollbar_y.Get() + 1)
        MouseMove(SCENE_SCROLLBAR_X + 1, last_scrollbar_y.Get() + 1)
        Sleep(150)
        MouseMove(SCENE_SCROLLBAR_X, last_scrollbar_y.Get() + 1)
        MouseMove(SCENE_SCROLLBAR_X - 1, last_scrollbar_y.Get() + 1)
        MouseMove(SCENE_SCROLLBAR_X + 1, last_scrollbar_y.Get() + 1)
        Send('{LButton up}')
        Sleep(50)
        Send('{LButton up}')
        Sleep(50)

        green_tile := GetGreenTilePos()

        if green_tile == 0 {
            if last_green_tile_y.Get() != -1 {
                MouseMove(SCREEN_PAGES_X, last_green_tile_y.Get())
                LongPress('LButton', 50, 50)
                LongPress('LButton', 50, 50)
            }
        } else {
            last_green_tile_y.Set(green_tile)
        }
    }
    RestoreMousePosition(true, BarManip)
}

OpenSceneBrowser() {
    color := PixelGetColor(20, 222, "RGB")

    ; Inactive color
    if color = "0x464646" or color = "0x353535" {
        MouseMove(20, 222)
        LongPress("LButton", 50, 150)
        Sleep(100)
    }

    MouseMove(150, 185)
    ; LongPress("LButton", 50, 50)
    Sleep(150)
    LongPress("LButton", 50, 50)
    Sleep(100)

    if WinActive('ahk_group KKStudio') {
        SetTimer(SceneBrowserWorker, 150)
    }
}

SelectSceneInBrowser() {
    if ArrayIncludes(['0xFAFAFA', '0xF9F9F9'], PixelGetColor(823, 675, 'RGB')) {
        MouseMove(823, 675)
        LongPress('LButton', 50, 100)
    } else {
        LongPress('LButton', 50, 50)
        PixelWait(823, 675, [0xFAFAFA, 0xF9F9F9])

        MouseMove(823, 675)
        Sleep(50)
        LongPress('LButton', 50, 100)
        LongPress('LButton', 100, 50)
    }

    screen_col := CGdip.Bitmap.FromScreen(SCENE_SCROLLBAR_X '|1|1|' A_ScreenHeight)

    ; Loop 1000 {
    ;     LogMessage("" screen_col.GetPixel(0, A_Index))
    ; }

    ; screen := CGdip.Bitmap.FromScreen('1|' 1 '|1980|' A_ScreenHeight)

    green_tile := GetGreenTilePos()

    if green_tile > 0 {
        last_green_tile_y.Set(green_tile)
    }

    current_scrollbar_y := SCENE_SCROLLBAR_START_Y

    loop {
        ; MsgBox(screen.GetPixel(0, current_scrollbar_y))

        pixel_color := screen_col.GetPixel(0, current_scrollbar_y - 1)
        ; color := PixelGetColor(SCENE_SCROLLBAR_X, current_scrollbar_y, 'RGB')

        if pixel_color == SCENE_SCROLLBAR_COLOR {
            green_tile_visible := GetGreenTilePos()
            LogMessage('selected-at: ' current_scrollbar_y)
            LogMessage('green-tile-visible: ' green_tile_visible)

            if green_tile_visible and WinActive('ahk_group KKStudio') {
                last_scrollbar_y.Set(current_scrollbar_y)
            }
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
F16:: {
    if IsSceneBrowserOpen() {
        LogMessage('browser-open: true')
        RestoreMousePosition(false, SelectSceneInBrowser)
    } else {
        LogMessage('browser-open: false')
        RestoreMousePosition(true, OpenSceneBrowser)
    }
}

; Camera cycling
last_cycle := -1
last_cam := -1

F24 & RButton:: {
    global last_cycle, last_cam

    if last_cycle == -1 or last_cycle + 10000 < A_TickCount {
        wid := WinActive()
        LogMessage('start cycle up' wid)
        WinActivate('ahk_class Progman')
        WinActivate(wid)

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

F24 & LButton:: {
    global last_cycle, last_cam

    if last_cycle == -1 or last_cycle + 10000 < A_TickCount {
        wid := WinActive()
        LogMessage('start cycle down' wid)
        WinActivate('ahk_class Progman')
        WinActivate(wid)

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

SCREEN_PAGES_X := 1660
SCREEN_PAGES_START_Y := 276
SCREEN_PAGES_END_Y := 900
GREEN_TILE_SEARCH_COLOR := 0xff00d900

GetGreenTilePos() {
    tiles_column := CGdip.Bitmap.FromScreen(SCREEN_PAGES_X '|1|1|' A_ScreenHeight)

    Loop SCREEN_PAGES_END_Y - SCREEN_PAGES_START_Y {
        i := A_Index
        y := SCREEN_PAGES_START_Y + i
        pixel_color := tiles_column.GetPixel(0, y)

        if pixel_color == GREEN_TILE_SEARCH_COLOR {
            ; 1-indexed height, 0 return means not found (false)
            return y + 1
        }
    }

    return 0
}

F22 & LButton:: {
    MouseMove(435, 618)
    LongPress('LButton', 150, 50)

    Loop 60 {
        Send('{WheelUp}')
    }

    MouseMove(365, 305)
    Sleep(50)
    LongPress('LButton', 50, 50)
    MouseMove(365, 240)
    LongPress('LButton', 50, 50)
}

F22 & RButton:: {
    ; 21 rows, 5 scrolls = 4 rows scrolled. 1.2 multiplier
    Send(RepeatString('{WheelDown}', Floor(21 * 1.2)))

    MsgBox(GetGreenTilePos())
}

F23 & RButton::^i
F23 & MButton::!v

F2::SendQueue('{Shift down}', 25, 'r', 25, '{Shift up}', 25, RepeatString('{BS}', 30))

ScrollLock & F24:: {
    Send('{ScrollLock up}{g down}')
}

ScrollLock & F24 up:: {
    Send('{ScrollLock up}{g up}')
}

#HotIf
