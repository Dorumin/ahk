#Include ../src/all.ahk

#HotIf WinActive("ahk_exe dontstarve_steam_x64.exe")

; Yes, they're backwards
WheelLeft::SendQueue('e', 100)
WheelRight::SendQueue('q', 100)

Pause::WheelUp
Insert::WheelDown

; Quick sell
F22:: RestoreMousePosition(true, () => (
    Click()
    Sleep(100)
    MouseMove(1180, 985, 0)
    Sleep(100)
    Click(1180, 985)
    Sleep(100)
    MouseMove(960, 820, 0)
    Sleep(100)
    Click(960, 820)
    Sleep(100)
    MouseMove(790, 615, 2)
    Sleep(100)
    Click(790, 615)
    Sleep(100)
))

F20::W
F19::A
F23::S
F21::D

#HotIf
